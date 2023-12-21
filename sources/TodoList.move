module my_addrx::todolist{
    
    // Required Imports 
    use aptos_framework::event;
    use aptos_framework::account;
    use std::signer;
    use std::string::String;
    use aptos_std::table::{Self, Table};

    // Errors
    const E_NOT_INITIALIZED: u64 = 1;
    const ETASK_DOESNT_EXIST: u64 = 2;
    const ETASK_IS_COMPLETED: u64 = 3;

    // Struct to initialize a list for an account with - Tasks, Number of Tasks and task Event handler
    struct TodoList has key {
        tasks: Table<u64, Task>,
        tasks_count: u64,
        set_task_event: event::EventHandle<Task>,
    }

    // struct for a task

    struct Task has drop, store, copy {
        task_id: u64,
        address: address,
        content: String,
        completed: bool,
    }

// Initialize a todolist with signer account
    public entry fun create_todo_list(account: &signer){
        let task_holder = TodoList{
            tasks: table::new(),
            set_task_event: account::new_event_handle<Task>(account),
            tasks_count:0,
        };

        move_to(account, task_holder);
    }

    public entry fun create_task(account: &signer, content:String) acquires TodoList {
        // get the address of the user that called the function
        let signer_addr = signer::address_of(account);
        // check if the TodoList is already present
        assert!(exists<TodoList>(signer_addr), E_NOT_INITIALIZED);

        // todo_list to create references and add a task
        let todo_list = borrow_global_mut<TodoList>(signer_addr);
        let counter = todo_list.tasks_count+1;
        let new_task = Task {
            task_id: counter,
            address: signer_addr,
            content,
            completed: false,
        };

        // upserting / adding new ask to list

        table::upsert(&mut todo_list.tasks, counter, new_task);
        // update task counter
        todo_list.tasks_count = counter;
        // emitting a task
        event::emit_event<Task>(&mut borrow_global_mut<TodoList>(signer_addr).set_task_event,new_task);



    }

    public entry fun complete_task(account: &signer, task_id: u64) acquires TodoList {
        let signer_addr = signer::address_of(account);
        assert!(exists<TodoList>(signer_addr), E_NOT_INITIALIZED);
        let todo_list = borrow_global_mut<TodoList>(signer_addr);
        assert!(table::contains(&todo_list.tasks, task_id), ETASK_DOESNT_EXIST);
        let task_record = table::borrow_global_mut(&mut todolist.tasks, task_id);
        assert!(task_record.completed == false, ETASK_IS_COMPLETED);
        task_record.completed = true;
    }
}