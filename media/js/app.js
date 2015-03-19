$(function () {
    var $nav = $('.nav');
    var $welcome = $('.section.welcome');
    var $rsvp_form = $('#rsvp_form');

    // Welcome page
    if (window.location.pathname === '/') {
        $('.welcome .flash .close').click(function () {
            $('.welcome .flash_background').fadeOut(200);
        });

        $('body').click(function () {
            $('.welcome .flash_background').fadeOut(200);
        });

        $('.welcome .flash').click(function (event) {
            event.stopPropagation();
        });
    }

    // Registry page
    if (window.location.pathname === '/registry') {
        var wait_for_iframe = function () {
            $('.footer').hide();
            $('.registry_container').hide();

            interval = setInterval(function () {
                $('iframe').load(function () {
                    $('.nav_elems').css('margin-right', 0);
                    $('.spinner').hide();
                    $('.footer').show();
                    $('.registry_container').show();
                    clearInterval(interval);
                });
            }, 10);
        }

        wait_for_iframe();
    }

    // RSVP page
    if (window.location.pathname === '/rsvp') {
        $(document).on('scroll', function () {
            var top = Math.max($('.nav').outerHeight(), $(window).scrollTop());
            $('.flash').css('top', top);
        });

        $('.rsvp .cancel').click(function () {
            $('.flash').fadeOut(200);
        });

        function validate_form() {
            var name = $rsvp_form.find('#name').val()
            var attending_yes = $rsvp_form.find('#attending_yes').is(':checked');
            var attending_no = $rsvp_form.find('#attending_no').is(':checked');

            return name && (attending_yes || attending_no)
        }

        $rsvp_form.submit(function (event) {
            if (!validate_form()) {
                event.preventDefault();
                $('.rsvp .flash').fadeIn(200);
            } else {
                $('.spinner').css('visibility', 'visible');
            }
        });

        function add_locations(map) {
            $.get('/locations', function (response) {
                response.forEach(function (location) {
                    latlng = location.replace(/[()\ ]/g, '').split(',');
                    new google.maps.Marker({
                        map:map,
                        icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png',
                        position: new google.maps.LatLng(parseFloat(latlng[0]), parseFloat(latlng[1]))
                    });
                });
            });
        }

        function initialize_map() {
            var mapCanvas = document.getElementById('map');
            var latlng = $('.latlng');
            var middle_of_usa = new google.maps.LatLng(37.09024, -95.712891);
            var mapOptions = {
                center: middle_of_usa,
                zoom: 4,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            var map = new google.maps.Map(mapCanvas, mapOptions);
            var marker = new google.maps.Marker({
                map:map,
                draggable: true,
                title: 'Where are you from?',
                position: middle_of_usa
            });

            google.maps.event.addListener(marker, 'dragend', function() {
                latlng.val(this.getPosition().toString());
            });

            add_locations(map);
        }

        google.maps.event.addDomListener(window, 'load', initialize_map);
    }
});
