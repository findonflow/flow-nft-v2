// This transaction is what an account would run
/// to set itself up to receive NFTs

import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

access(all) fun main(user:Address): [String]{


    let messages : [String]=[]

    let signer = getAuthAccount<auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability, LoadValue) &Account>(user)

    let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")


    //this also works
    let col= signer.storage.borrow<&AnyResource>(from: collectionData.storagePath) as? &{NonFungibleToken.Collection}?
    if col != nil {
        messages.append("borrow using anyResource and then cast as restricted type")
    }else {

        messages.append("borrow using anyResource and then cast as restricted type, is empty")

    }
    return messages

}
