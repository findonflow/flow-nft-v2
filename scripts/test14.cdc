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

    //this is what will be in storage after  we have migrated a private path
    let preCap =signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(collectionData.storagePath)
    messages.append("cap ".concat(preCap.id.toString()))

    //debuging out what caps are here
    signer.capabilities.storage.forEachController(forPath: collectionData.storagePath,fun(scc: &StorageCapabilityController): Bool {
        messages.append("pre ".concat(scc.capabilityID.toString()).concat(" ").concat(scc.target().toString()))
        return true
    })


    //in order to create a path we have to juggle some stuff, would be nice to be able to do this cleaner i guess
    let storagePathIdentifer = collectionData.storagePath.toString().split(separator:"/")[1]
    let providerIdentifier = storagePathIdentifer.concat("Provider")
    let providerStoragePath = StoragePath(identifier: providerIdentifier)!


    //we save a string here to try to mess things up
    signer.storage.save("foo", to:providerStoragePath)

    //this will now panic if this stores anything but a cap
    let existingProvider= signer.storage.borrow<&Capability>(from: providerStoragePath) 
    if existingProvider==nil{
        let providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
        messages.append("issued providerCap ".concat(providerCap.id.toString()))
        //we save it to storage to memoize it
        signer.storage.save(providerCap, to: providerStoragePath)
    } else {
        //we add the check here that verifies that the cap we get can check as this type, although not really sure what happends here if this will panic if the type is something else?
        //do we need to get type and check subtype here?
        if !existingProvider!.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(){
            messages.append("we need to revoke")
        }
    }

    if let existingProvider2= signer.storage.borrow<&Capability>(from: providerStoragePath) {
        messages.append("find provider second time")
        messages.append(existingProvider2.getType().identifier)

        if existingProvider2.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(){
            //this works and we can verify that the cap was saved and we can get it subsequent times
            messages.append("is provider cap")
        } else {
            messages.append("is notprovider cap")
        }
    }

    signer.capabilities.storage.forEachController(forPath: collectionData.storagePath,fun(scc: &StorageCapabilityController): Bool {
        messages.append("post ".concat(scc.capabilityID.toString()).concat(" ").concat(scc.target().toString()))
        return true
    })
    //here we will have 2 scc's. one is the one migrated from the private path, the other one is the one we have memoized in the private path

    return messages

}
