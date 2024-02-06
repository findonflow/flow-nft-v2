/// This transaction is what an account would run
/// to set itself up to receive NFTs

import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"

access(all) fun main(user:Address) : [String]{

    let messages :[String]=[]

    let signer = getAuthAccount<auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")

    //if we save something here it will not work
    signer.storage.save("foo", to:collectionData.storagePath)


    // Return early if the account already has a collection
    if signer.storage.borrow<&ExampleNFT.Collection>(from: collectionData.storagePath) != nil {
        return messages
    }

    // Create a new empty collection
    let collection <- ExampleNFT.createEmptyCollection(nftType: Type<@ExampleNFT.NFT>())

    //this will not work if the storage has something else there already
    // save it to the account
    signer.storage.save(<-collection, to: collectionData.storagePath)

    // create a public capability for the collection
    signer.capabilities.unpublish(collectionData.publicPath)
    let collectionCap = signer.capabilities.storage.issue<&ExampleNFT.Collection>(collectionData.storagePath)
    signer.capabilities.publish(collectionCap, at: collectionData.publicPath)
    return messages
}
