/// This transaction is what an account would run
/// to set itself up to receive NFTs

import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

access(all) fun main(user:Address): [String]{


    let messages : [String]=[]

    let signer = getAuthAccount<auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability, LoadValue) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")


    let collection <- UniversalCollection.createEmptyCollection(identifier: "foo", type: ExampleNFT.getType())
    signer.storage.save(<- collection, to:collectionData.storagePath)



    // Return early if the account already has a collection
    if let storedType =signer.storage.type(at: collectionData.storagePath) {
        if storedType.isSubtype(of: Type<@{NonFungibleToken.Collection}>()) {
            messages.append("store something that is NFT collection")
        }

        if storedType != Type<&ExampleNFT.Collection>() {
            messages.append("we do not store exampleNFT collection")
            destroy  signer.storage.load<@AnyResource>(from: collectionData.storagePath)

            let collection <- ExampleNFT.createEmptyCollection(nftType: Type<@ExampleNFT.NFT>())

            signer.storage.save(<-collection, to: collectionData.storagePath)
            messages.append("we could load and destory and add new collection")
            //this works as expected we get here
        } 
    }
    return messages

}
