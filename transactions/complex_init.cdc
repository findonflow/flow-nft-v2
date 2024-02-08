import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

transaction {

    let  providerCap : Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>

    prepare(signer: auth(Storage, Capabilities, BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account) {

        let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")

        let storagePathIdentifer = collectionData.storagePath.toString().split(separator:"/")[1]
        let providerIdentifier = storagePathIdentifer.concat("Provider")
        let providerStoragePath = StoragePath(identifier: providerIdentifier)!


        /*
        let collection <- UniversalCollection.createEmptyCollection(identifier: "foo", type: ExampleNFT.getType())
        //lets assume something else is here
        signer.storage.save(<- collection, to:providerStoragePath)

        let capType = Type<Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>>()
        let storedType=signer.storage.type(at: providerStoragePath)!

        if !storedType.isSubtype(of:capType) {
            log("subtype")
        } else {
            log("nooo")
        }
        log(storedType)
        */
        //if this stores anything but this it will panic, but I guess that is ok here?
        let existingProvider= signer.storage.copy<Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>>(from: providerStoragePath) 

        if existingProvider==nil {
            self.providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
            //we save it to storage to memoize it
            signer.storage.save(self.providerCap, to: providerStoragePath)
            log("create new cap")
        }else {
            self.providerCap= existingProvider!
            log("existing")
        }

        /*
        //! as! Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>

        let cap = existingProvider!
        let capType = cap.getType()
        log(capType.identifier)

        if capType == providerType {
            log("same")
        }
        if capType.isSubtype(of: providerType) {
            log("existing cap")
            self.providerCap= existingProvider! as! Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>
        }else {
            log(existingProvider!.getType().identifier)
            log("We have something stored that is not our cap")
            self.providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
        }
        //        }

        //this did not work
        //existingProvider.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>() //this returns false but the below one is
        //Cadence log: "Capability<auth(A.f8d6e0586b0a20c7.NonFungibleToken.Withdraw)&{A.f8d6e0586b0a20c7.NonFungibleToken.Collection}>"
        //
        //looks like i cannot cast this. 
        //error: failed to force-cast value: expected type `Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>`, got `&Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>`
    } else {
        //added this line so that it compilesz
        self.providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
        log(existingProvider!.getType().identifier)
        log("We have something stored that is not our cap")
    }
    */
}
}

