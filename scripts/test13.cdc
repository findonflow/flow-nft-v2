import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

access(all) fun main(user:Address): [String]{


    let messages : [String]=[]

    let signer = getAuthAccount<auth(Storage, Capabilities) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")


    let collection <- collectionData.createEmptyCollection()
    signer.storage.save(<-collection, to: collectionData.storagePath)

    //this is what will be in storage after  we have migrated a public path
    let preCap =signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(collectionData.storagePath)
    messages.append("cap ".concat(preCap.id.toString()))

    let pre2Cap =signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(collectionData.storagePath)
    messages.append("cap ".concat(pre2Cap.id.toString()))


    signer.capabilities.storage.forEachController(forPath: collectionData.storagePath,fun(scc: &StorageCapabilityController): Bool {
        messages.append("pre ".concat(scc.capabilityID.toString()).concat(" ").concat(scc.target().toString()))
        return false
    })


    let storagePathIdentifer = collectionData.storagePath.toString().split(separator:"/")[1]
    let providerIdentifier = storagePathIdentifer.concat("Provider")
    let providerStoragePath = StoragePath(identifier: providerIdentifier)!

    let existingProvider= signer.storage.borrow<&Capability>(from: providerStoragePath) 
    if existingProvider==nil{
        let providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
        messages.append("issued providerCap ".concat(providerCap.id.toString()))
        //we save it to storage to memoize it
        signer.storage.save(providerCap, to: providerStoragePath)
    } else {
        if !existingProvider!.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(){
            messages.append("we need to revoke")
        }
    }

    if let existingProvider2= signer.storage.borrow<&Capability>(from: providerStoragePath) {
        messages.append("find provider second time")
        messages.append(existingProvider2.getType().identifier)

        if existingProvider2.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(){
            messages.append("is provider cap")
        } else {
            messages.append("is notprovider cap")
        }
    }

    signer.capabilities.storage.forEachController(forPath: collectionData.storagePath,fun(scc: &StorageCapabilityController): Bool {
        messages.append("post ".concat(scc.capabilityID.toString()).concat(" ").concat(scc.target().toString()))
        return false
    })

    return messages

}
