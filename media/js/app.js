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

    // Sticky navbar
    $(window).scroll(function (event) {
        if ($(this).scrollTop() > $welcome.height() && $nav.css('position') !== 'fixed') {
            $nav.css({
                position: 'fixed',
                top: '0px'
            });
        } else if ($(this).scrollTop() < $welcome.height() && $nav.css('position') === 'fixed') {
            $nav.css({
                position: 'static'
            });
        }
    });

    // Scroll to section
    $('.nav_elem').click(function (event) {
        var id = $(event.target).attr('href');

        event.preventDefault();
        $('html, body').animate({
            scrollTop: ($(id).offset().top - (2 * $nav.height()))
        }, 800);
    });


    // Plus one input
    $('#num_guests').change(function (event) {
        var $guest_names_container = $('.guest_names_container');
        var val = $(event.target).val();
        var num_guests = function () { return $guest_names_container.find('.block').length; }
        var prototype = '' +
            '<div class="block">' +
                '<label for="plus_one_name_" class="plus_one_name">Guest name</label>' +
                '<input type="text" id="plus_one_name" name="plus_ones[]" />' +
            '</div>'

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
                '<button class="remove_song">-</button>' +
            '</div>'

        $song_container.append(prototype);
        $('.remove_song').click(function (event) {
            event.preventDefault();
            $(event.target).parent().remove();
        });
    });


});
