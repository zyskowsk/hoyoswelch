$(function () {
    var $nav = $('.nav');
    var $welcome = $('.section.welcome');

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

        $guest_names_container.empty();
        for (var i = 0; i < val; i++) {
            var prototype = '' +
                '<div class="block">' +
                    '<label for="plus_one_name_' + i +'" class="plus_one_name">Guest name</label>' +
                    '<input type="text" id="plus_one_name' + i +'" name="plus_ones[]" />' +
                '</div>'
            $guest_names_container.append(prototype);
        }
    });

});
