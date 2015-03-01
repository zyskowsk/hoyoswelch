$(function () {
    var $nav = $('.nav');
    var $welcome = $('.section.welcome');
    var $rsvp_form = $('#rsvp_form');

    function validate_form() {
        var name = $rsvp_form.find('#name').val()
        var attending_yes = $rsvp_form.find('#attending_yes').is(':checked');
        var attending_no = $rsvp_form.find('#attending_no').is(':checked');

        return name && (attending_yes || attending_no)
    }

    // Plus one input
    $('#num_guests').change(function (event) {
        var $guest_names_container = $('.guest_names_container');
        var val = parseInt($(event.target).val(), 10);
        var num_guests = function () { return $guest_names_container.find('.block').length; }
        var prototype = '' +
            '<div class="block">' +
                '<label for="plus_one_name" class="plus_one_name">Guest name</label>' +
                '<input type="text" id="plus_one_name" name="plus_ones[]" />' +
            '</div>'

        if (val === 1) {
            $('.guests_copy').html('guest');
        } else {
            $('.guests_copy').html('guests');
        }

        if (val > num_guests()) {
            while (num_guests() < val) {
                $guest_names_container.append(prototype);
            }
        } else {
            while (num_guests() > val) {
                _.last($guest_names_container.find('.block')).remove();
            }
        }
    });

    // Validate form
    $rsvp_form.submit(function (event) {
        if (!validate_form()) {
            event.preventDefault();
            $('.rsvp .flash').fadeIn(300);
        }
    });

    // Handle songs
    $('.add_song').click(function (event) {
        event.preventDefault();
        var $song_container = $('.songs_container');
        var prototype = '' +
            '<div class="block">' +
                '<input type="text" id="song_name" name="songs[]" />' +
                '<button class="remove_song">x</button>' +
            '</div>'

        $song_container.append(prototype);
        $('.remove_song').click(function (event) {
            event.preventDefault();
            $(event.target).parent().remove();
        });
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
});
