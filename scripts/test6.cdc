/// This transaction is what an account would run
/// to set itself up to receive NFTs

import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"

access(all) fun main(user:Address): [String]{


    let messages : [String]=[]

    let signer = getAuthAccount<auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")


    // Return early if the account already has a collection
    if let storedType =signer.storage.type(at: collectionData.storagePath) {
        if storedType.isSubtype(of: Type<@{NonFungibleToken.Collection}>()) {
            messages.append("is nft collection")
        }
    } else {
        messages.append("does not store anything")
    }


    return messages

}
