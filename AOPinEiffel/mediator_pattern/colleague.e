<!--@+leo-ver=5-thin-->
<!--@+node:agarciafdz.20240507230016.1: * @file colleague.e-->
<!--@+all-->
<!--@+node:agarciafdz.20240507225203.1: ** <<MEDIATOR_LIBRARY_COLLEAGUE>>-->
deferred class
    COLLEAGUE
feature
    make(a_mediator: like mediator)
        -- Set mediator to a_mediator
        require
            a_mediator_not_void: attached a_mediator
        do
            mediator := a_mediator
            create event
        ensure
            mediator_set: mediator = a_mediator
        end
        
    mediator: MEDIATOR[COLLEAGE]
    event: EVENT_TYPE[TUPLE]

feature
    subscribed: BOOLEAN
        -- Is current subscribed to other colleages event?
        deferred
        end
        
    unsubscribed: BOOLEAN
        deferred
        end

feature
    change
        -- Do something that changes current colleagues state.
        do
            do_change
            event.publish([])
        end
    
    do_something
        deferred
        end

feature
    do_change
        deferred
        end

invariant
    mediator_not_void: attached mediator
    event_not_void: attached event
    
<!--@-all-->
<!--@-leo-->
