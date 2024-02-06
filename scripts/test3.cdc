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
    signer.storage.save(<- collection, to:collectionData.storagePath)


    //this if check will fail, but it does not panic
    if signer.storage.check<&ExampleNFT.Collection>(from: collectionData.storagePath) {
        return  "fail"
    }
    return "OK; storage did not contain exampleNFT collection"
}
