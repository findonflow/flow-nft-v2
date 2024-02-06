/// This transaction is what an account would run
/// to set itself up to receive NFTs

import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

access(all) fun main(user:Address): String{


    let signer = getAuthAccount<auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")

    let collection <- UniversalCollection.createEmptyCollection(identifier: "foo", type: ExampleNFT.getType())
    //if we save something here it will not work
    signer.storage.save(<- collection, to:collectionData.storagePath)


    //This will panic
    if signer.storage.borrow<&ExampleNFT.Collection>(from: collectionData.storagePath) != nil {
        return  "ok"
    }
    return "fail"
}
