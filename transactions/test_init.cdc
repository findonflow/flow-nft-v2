import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"

transaction {

    prepare(signer: auth(Storage, Capabilities, BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account) {

        let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")


        let collection <- collectionData.createEmptyCollection()
        signer.storage.save(<-collection, to: collectionData.storagePath)

        //this is what will be in storage after  we have migrated a public path
        let preCap =signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(collectionData.storagePath)
        log("cap ".concat(preCap.id.toString()))

        let pre2Cap =signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(collectionData.storagePath)
        log("cap ".concat(pre2Cap.id.toString()))


        //this only shows the first cap
        signer.capabilities.storage.forEachController(forPath: collectionData.storagePath,fun(scc: &StorageCapabilityController): Bool {
            log("pre ".concat(scc.capabilityID.toString()).concat(" ").concat(scc.target().toString()))
            return false
        })


        let storagePathIdentifer = collectionData.storagePath.toString().split(separator:"/")[1]
        let providerIdentifier = storagePathIdentifer.concat("Provider")
        let providerStoragePath = StoragePath(identifier: providerIdentifier)!

        let existingProvider= signer.storage.borrow<&Capability>(from: providerStoragePath) 
        if existingProvider==nil{
            let providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
            log("issued providerCap ".concat(providerCap.id.toString()))
            //we save it to storage to memoize it
            signer.storage.save(providerCap, to: providerStoragePath)
        } else {
            if !existingProvider!.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(){
                log("we need to revoke")
            }
        }

        if let existingProvider2= signer.storage.borrow<&Capability>(from: providerStoragePath) {
            log("find provider second time")
            log(existingProvider2.getType().identifier)

            if existingProvider2.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(){
                log("is provider cap")
            } else {
                log("is notprovider cap")
            }
        }

        signer.capabilities.storage.forEachController(forPath: collectionData.storagePath,fun(scc: &StorageCapabilityController): Bool {
            log("post ".concat(scc.capabilityID.toString()).concat(" ").concat(scc.target().toString()))
            return false
        })
    }
}
/*
*this is the log this prints

Cadence log: "cap 3"
Cadence log: "cap 4"
Cadence log: "pre 3 /storage/cadenceExampleNFTCollection"
Cadence log: "issued providerCap 5"
Cadence log: "find provider second time"
Cadence log: "Capability<auth(A.f8d6e0586b0a20c7.NonFungibleToken.Withdraw)&{A.f8d6e0586b0a20c7.NonFungibleToken.Collection}>"
Cadence log: "is provider cap"
Cadence log: "post 3 /storage/cadenceExampleNFTCollection"
*/
