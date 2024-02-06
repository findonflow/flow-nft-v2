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

    //this will panic as the thing we are trying to load is not a resource
    let col= signer.storage.borrow<&AnyResource>(from: collectionData.storagePath) as? &{NonFungibleToken.Collection}?
    if col == nil {
        messages.append("could not borrow string as AnyResource")
    }
    return messages

}
