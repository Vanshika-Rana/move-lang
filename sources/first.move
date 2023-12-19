//first ever move program
module my_addrx:: Sample{
    use std::debug;
    fun sample_fun(){
        debug::print(&2373547);
    }

    #[test]
    fun testing(){
        sample_fun();
    }
}