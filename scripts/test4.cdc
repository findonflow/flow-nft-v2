/// This transaction is what an account would run
/// to set itself up to receive NFTs

import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

access(all) fun main(user:Address): [String]{


    let messages : [String]=[]

    let signer = getAuthAccount<auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")

    let collection <- UniversalCollection.createEmptyCollection(identifier: "foo", type: ExampleNFT.getType())

    messages.append(collection.getType().identifier)
    signer.storage.save(<- collection, to:collectionData.storagePath)

    // Return early if the account already has a collection
    if signer.storage.check<&{NonFungibleToken.Collection}>(from: collectionData.storagePath) {
        messages.append("is an nft collection")
    }else {
        //this check fails here, and to me that is not what i expect
        messages.append("cannot check that this implements interface {NonFungibleToken.Collection}")
    }
    return messages
}
