import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

access(all) fun main(user:Address): [String]{


    let messages : [String]=[]

    let signer = getAuthAccount<auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability, LoadValue) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")


    let collection <- collectionData.createEmptyCollection()
    signer.storage.save(<-collection, to: collectionData.storagePath)

    //if we previously had a storage path there will be created a capcon for it but it will not be saved anywhere
    //    signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(collectionData.storagePath)


    let storagePathIdentifer = collectionData.storagePath.toString().split(separator:"/")[1]
    let providerIdentifier = storagePathIdentifer.concat("Provider")
    let providerStoragePath = StoragePath(identifier: providerIdentifier)!

    let existingProvider= signer.storage.borrow<&Capability>(from: providerStoragePath) 
    if existingProvider==nil{
        messages.append("could not find provider")
        let providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
        signer.storage.save(providerCap, to: providerStoragePath)
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

    return messages

}
