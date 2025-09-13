#[Starknet::interface]

trait ICounter<T> {
    fn get_counter() -> T;
    fn increase_counter(ref self: T);
    fn decrease_counter(ref self: T);
    fn set_counter(ref self: T, new_value: u32 );
    fn reset_counter(ref self: T)
}

#[Starknet::contract]
mod Counter {
    use super::ICounter;
    use OwnableComponent::InternalImpl;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet:{:ContractAddress, get_caller_address, get_contract_address};
    use openzepplin::Ownable::OwnableComponent;
    use openzepplin_access::Ownable::OwnableComponent
    use openzepplin_token::ERC20::interface::{IERC20Dispatch,IERC20DispatchTrait};


    componet!(path: OwnableComponent,Storage: Ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<Contractstate>;
    impl InternalImpl = OwnableComponent::InternalImpl<Contractstate>;
    #[event]
    #[dervie(Drop, starknet::Event)]
    enum Event {
        CounterChanged: CounterChanged,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterChanged {
        #[key]
        pub caller: ContractAddress,
        pub old_value: u32,
        pub new_value: u32,
        pub reason: ChangeReason
    }
    #[derive(Drop, Copy,Serde)]
    enum ChangeReason {
        Increase,
        Decrease,
        Reset,
        Set,
    }



    #[storage]
    struct Storage {
        counter: u32,
        #[substorage(v0)]
        ownable : OwnableComponent::Storage,
    }

    #[constructor]
    fn constructor(ref self: Contractstate,init_value: u32,owner: ContractAddress) {
        self.counter.write(init_value);
        self.owner.write(owner);   
        self.ownable.initialize(owner);
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounnter<Contractstate> {
        fn get_counter(self @Contractstate) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: Contractstate) {
            let current_value = self.counter.read();
            self.counter.write(current_value + 1);
            let event : CounterChanged = CounterChanged {
                old_value: current_value,
                new_value: current_value + 1,
                caller: starknet::get_caller_address()
                reason: ChangeReason::Increase,
            };
            selt.emit(event);
        }
        fn decrease_counter(ref self: Contractstate) {
            let current_value = self.counter.read();
            assert!(current_value > 0, "Counter cannot be negative");
            self.counter.write(current_value - 1);
            let event : CounterChanged = CounterChanged {
                old_value: current_value,
                new_value: current_value + 1,
                caller: starknet::get_caller_address()
                reason: ChangeReason::Increase,
            };
            selt.emit(event);
        }

        fn set_counter(ref self: Contractstate,new_value: u32) {
            self.ownable.assert_only_owner();
            let current_value = self.counter.read();
            self.counter.write(new_value);
            let event : CounterChanged = CounterChanged {
                old_value: current_value,
                new_value: new_value,
                caller: starknet::get_caller_address()
                reason: ChangeReason::Set,
            };
            selt.emit(event);
        }

        fn reset_counter(ref self: Contractstate) {
            let payment_amount : u256 = 1000000000000000000;
            let strk_token : ContractAddress = 0x
            let contract :  get_contract_address();

            let dispatcher = IERC20Dispatch{contract_address: strk_token};


            let balance = IERC20Dispatch{contract_address: strk_amount}.balance_of(caller);
            assert!(balance >= payment_amount, "Insufficient STRK balance to reset counter");
           
            let allowance = IERC20Dispatch{
                contract_address: strk_token
            }.allowance(caller,contract);
            assert!(allowance >= payment_amount, "Insufficient STRK allowance to reset counter");
            
            let owner = self.ownable.owner()
            dispatcher.transfer_from(caller, owner, payment_amount);
           asset!(success,"STRK token transfer failed during counter reset");
            self.counter.write(0);
            let event : CounterChanged = CounterChanged {
                old_value: current_value,
                new_value: 0,
                caller: starknet::get_caller_address()
                reason: ChangeReason::Reset,
            };
            selt.emit(event);
        }
    }

}
