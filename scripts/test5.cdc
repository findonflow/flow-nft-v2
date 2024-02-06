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
    signer.storage.save(<- collection, to:collectionData.storagePath)

    // Return early if the account already has a collection
    let storedType =signer.storage.type(at: collectionData.storagePath)!
    if storedType.isSubtype(of: Type<@{NonFungibleToken.Collection}>()) {
        //this works, you need to fint the type and check that it is a subtype of what we want
        messages.append("is nft collection")
    }


    return messages

}
