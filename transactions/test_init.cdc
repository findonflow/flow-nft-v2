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

        //this only shows the first cap
        signer.capabilities.storage.forEachController(forPath: collectionData.storagePath,fun(scc: &StorageCapabilityController): Bool {
            log("pre ".concat(scc.capabilityID.toString()).concat(" ").concat(scc.target().toString()))
            return true
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
            return true
        })
    }
}

