(function() {
    window.Search = {
        init: function() {
            $('.search .search-box').on('click', function(e) {
                console.log("ian");
                e.preventDefault();
            });

            $('.search__close').on('click', function(e) {
                $('#search-input').val("");
            })
        }
    }
})();
