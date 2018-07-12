({
    init: function (cmp) {
        var action = cmp.get("c.getCarouselSlides");

        action.setCallback(this, function (response) {
            var Carousel = response.getReturnValue();
            var slides = [],
                communityPrefix = '';

            if (typeof $A.get("$SfdcSite") !== 'undefined') {
                communityPrefix = $A.get("$SfdcSite").pathPrefix;
            }

            for (var i = 0; i < Carousel.length; i = i + 1) {
                slides.push({
                    index: i + 1,
                    background: Carousel[i].acslider__Image__c,
                    content: Carousel[i].acslider__Content__c
                });
            }

            cmp.set('v.slidesLength', Carousel.length);
            cmp.set('v.data', slides);
        });
        $A.enqueueAction(action);
    },

    switchSlide: function (cmp, index) {
        // remove 'selected' class from active slide and switcher
        $A.util.removeClass(document.querySelector('li.slide.selected'), "selected");
        $A.util.removeClass(document.querySelector('span.carousel-switcher.selected'), "selected");

        // add 'selected' class to next active slide and switcher
        $A.util.addClass(document.querySelector('li.slide[data-slide="' + index + '"]'), "selected");
        $A.util.addClass(document.querySelector('span.carousel-switcher[data-switcher-for="' + index + '"]'), "selected");

        // update current slide
        cmp.set('v.currentSlide', index);
    },

    getNextSlideByDirection: function (cmp, direction) {
        var currentSlide = cmp.get('v.currentSlide');
        var slidesLength = cmp.get('v.slidesLength');

        return direction === 'next' ?
            (currentSlide + 1 > slidesLength ? 1 : currentSlide + 1) :
            (currentSlide - 1 < 1 ? slidesLength : currentSlide - 1);
    },

    // id of interval
    interval: 0,

    /**
     * Run loop for slider
     **/
    loop: function (cmp) {
        var self = this;
        this.interval = setInterval($A.getCallback(function () {
            if (cmp.isValid()) {
                self.switchSlide(cmp, self.getNextSlideByDirection(cmp, 'next'));
            }
        }), cmp.get('v.interval'));
    }
});