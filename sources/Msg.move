module my_addrx::Message {
    use std::string::{String,Self};
    use std::signer;
    use std::debug;
    use aptos_framework::account;

    struct Message has key{
        my_message: String
    }

    public entry fun create_message(account: &signer, msg:String) acquires Message{
        let signer_add = signer::address_of(account);
        if(!exists<Message>(signer_add)){
            let message = Message{
                my_message: msg
            };
        move_to(account, message);
        }
        else{
            let message = borrow_global_mut<Message>(signer_add);
            message.my_message=msg;
        }
    }
    #[test(admin=@0x123)]
    public entry fun test_create_message(admin:signer) acquires Message{
        account::create_account_for_test(signer::address_of(&admin));
       // add a message to the account
        create_message(&admin, string::utf8(b"third message"));
        message = borrow_global<Message>(signer::address_of(&admin)); // get the message
        debug::print( &message.my_message); //print message
    }
}