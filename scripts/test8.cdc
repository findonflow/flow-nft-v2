
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


    signer.storage.save("foo", to:collectionData.storagePath)



    // Return early if the account already has a collection
    if let storedType =signer.storage.type(at: collectionData.storagePath) {
        if storedType.isSubtype(of: Type<@{NonFungibleToken.Collection}>()) {
            messages.append("store something that is NFT collection")
        }

        if storedType != Type<&ExampleNFT.Collection>() {

            if storedType.isSubtype(of: Type<@AnyResource>()) {
                destroy  signer.storage.load<@AnyResource>(from: collectionData.storagePath)
            } else {
                signer.storage.load<AnyStruct>(from: collectionData.storagePath)
            }
            let collection <- ExampleNFT.createEmptyCollection(nftType: Type<@ExampleNFT.NFT>())

            //this will not work if the storage has something else there already
            // save it to the account
            signer.storage.save(<-collection, to: collectionData.storagePath)
            messages.append("we could load and destory and add new collection")
        } 
    }
    return messages

}
