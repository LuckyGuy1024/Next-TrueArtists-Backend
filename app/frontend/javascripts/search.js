(function() {
    window.Search = {
        init: function() {
            $('.search .search-box').on('click', function(e) {
                e.preventDefault();
            });

            $('#search-input').on("keypress", function(e) {
                let searchParams;
                let baseUrl = $(location).attr("href").split("?")[0]

                if (e.keyCode === 13) {
                    searchParams = $(this).val();
                    let url = baseUrl + "?query=" + searchParams
                    window.location.replace(url);
                }
            });

            $('.search__close').on('click', function(e) {
                $('#search-input').val("");
            })
        }
    }
})();
