({
    /**
     * Init function
     **/
    init: function (cmp, event, helper) {
        helper.init(cmp);
        helper.loop(cmp);
    },

    /**
     * Show next slide when "next arrow" is clicked
     **/
    prevSlide: function (cmp, event, helper) {
        helper.switchSlide(cmp, helper.getNextSlideByDirection(cmp, 'prev'));
    },

    /**
     * Show next slide when "next arrow" is clicked
     **/
    nextSlide: function (cmp, event, helper) {
        helper.switchSlide(cmp, helper.getNextSlideByDirection(cmp, 'next'));
    },

    /**
     * Switcher for slides
     **/
    switchSlide: function (cmp, event, helper) {
        helper.switchSlide(cmp, parseInt(event.target.getAttribute('data-switcher-for'), 0));
    },

    /**
     * Stop sliding when mouse over slider component
     **/
    mouseOverCmp: function (cmp, event, helper) {
        clearInterval(helper.interval);
    },

    /**
     * Continue sliding when mouse leaves slider component
     **/
    mouseOutCmp: function (cmp, event, helper) {
        helper.loop(cmp);
    }

});