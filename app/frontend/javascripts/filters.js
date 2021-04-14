(function() {
  window.Filters = {
    init: function() {
      $('.filter-checkbox .checkmark').on('click', function(e) {
        e.preventDefault();

        let $checkbox = $(this).parent().find('input');
        $checkbox.prop('checked', !$checkbox.prop('checked'));
        $(this).parent().toggleClass('checked');
      });

      $('.filter-section .multi-filter .multi-filter__selected').on('click', function(e) {
        e.preventDefault();
        $(this).parents('.multi-filter').toggleClass('active');
        $('body').toggleClass('filter-open');
      });

      $('.multi-filter__close').on('click', function(e) {
        e.preventDefault();

        $(this).parents('.multi-filter').toggleClass('active');
        $('body').toggleClass('filter-open');
      });

      $('.multi-filter__clear').on('click', function(e) {
        $(this).parents('.multi-filter').find('input[type="checkbox"]').prop('checked', false);
      });

      $('.multi-filter__apply').on('click', function(e) {
        e.preventDefault();

        let $all_checkboxes = $(this).parents('.multi-filter').find('input[type="checkbox"]');
        let $selected_checkboxes = $(this).parents('.multi-filter').find('input:checked');

        let filter_label = 'All Styles';

        if ($selected_checkboxes.length > 0) {
          if ($all_checkboxes.length != $selected_checkboxes.length) {

            let selected_values = {};
            let filterUrl = ""

            $selected_checkboxes.each(function(idx) {
              if(selected_values[$($selected_checkboxes[idx]).attr("name")] === undefined) {
                selected_values[$($selected_checkboxes[idx]).attr("name")] = [$($selected_checkboxes[idx]).val()]
              } else {
                selected_values[$($selected_checkboxes[idx]).attr("name")].push($($selected_checkboxes[idx]).val());
              }
            });
            
            for (k in selected_values){
              filterUrl += "&" + k + "=" + selected_values[k].join("%2C")
            };
            console.log(filterUrl);

          }
        }

        // $('.multi-filter__selected').text(filter_label);

        $('.multi-filter__close').click();

        $(this).parents('form').submit();
      });
    }
  }
})();