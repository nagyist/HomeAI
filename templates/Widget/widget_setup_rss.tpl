<div id="widgetSetup">
    <ul class="nav nav-tabs nav-tabs-white" id="widgetSetupNavigation">
        <li class="active"><a href="#widgetSetupTabBasic">Basic settings</a></li>
        <li class=""><a href="#widgetSetupTabRss">RSS feed settings</a></li>
        <li class=""><a href="#widgetSetupTabOutput">Output</a></li>
    </ul>

    <form id="widgetSetupForm" class="form-horizontal row-fluid">
        <div class="tab-content">

            <div id="widgetSetupTabBasic" class="tab-pane active">
                {include file='widget_setup_common.tpl' data=$data widget=$widget}
            </div>

            <div id="widgetSetupTabRss" class="tab-pane">
                <div class="control-group">
                    <label class="control-label span3">RSS feed URL</label>
                    <div class="controls span9">
                        <input type="text" name="url" class="span9" required placeholder="Add RSS URL to fetch..." />
                    </div>
                </div>

                <div class="control-group control-group-slider">
                    <label class="control-label span3">Item count</label>
                    <div class="controls span9">
                        <div id="widgetSetupCountSlider" class="sliderInput span9" data-min="1" data-max="20"></div>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label span3"></label>
                    <div class="controls span9 input-append">
                        <input name="limit" class="span2 pagination-right" required type="text" value="5" />
                        <span class="add-on">pc</span>
                    </div>
                </div>

                <div class="control-group">
                    <div class="controls span9 offset3">
                        <button id="testRssRequest" class="btn disabled" type="button">Test current configuration</button>
                    </div>
                </div>
            </div>

            <div id="widgetSetupTabOutput" class="tab-pane">
                <pre class="pre-scrollable"><em>Current RSS feed configuration not yet tested...</em></pre>
                <blockquote class="content hide"></blockquote>
            </div>
        </div>
    </form>
</div>


<script type="text/javascript">
    {literal}
    function getWidgetValidationRules() {
        var options = getWidgetValidationRulesDefault();

        var rules = {
            url: {
                required: true,
                url: true
            },
            limit: {
                required: true,
                digits: true,
                min: 1,
                max: 20
            }
        };

        jQuery.extend(options.rules, rules);

        return options;
    }

    function getWidgetData() {
        var container = jQuery('#widgetSetup');
        var form = container.find('form');
        var output = getWidgetDataDefault();
        var metadata = {
            type: 'rss',
            data: {}
        };

        var elements = {
            url: {
                selector: 'input[name=url]',
                type: 'text'
            },
            limit: {
                selector: 'input[name=limit]',
                type: 'integer'
            }
        };

        jQuery.each(elements, function(key, data) {
            var element = jQuery(data.selector, form);
            var row = element.parent().parent();
            var value = null;
            var valueOrg = element.val();
            var errors = false;

            switch (data.type) {
                case 'text':
                    value = jQuery.trim(element.val());
                    break;
                case 'integer':
                    value = parseInt(jQuery.trim(element.val()), 10);

                    if (isNaN(value)) {
                        value = 5;
                    }
                    break;
                default:
                    return true;
                    break;
            }

            // Store current value
            metadata['data'][key] = value;

            return true;
        });

        return jQuery.extend({}, output, {metadata: metadata});
    }

    jQuery(function () {
        var container = jQuery('#widgetSetup');
        var navigation = container.find('#widgetSetupNavigation');
        var tabBasic = container.find('#widgetSetupTabBasic');
        var tabSetup = container.find('#widgetSetupTabRss');
        var tabOutput = container.find('#widgetSetupTabOutput');
        var form = container.find('form');
        var slider = form.find('#widgetSetupCountSlider');
        var itemCount = form.find('input[name=limit]');

        navigation.find('a').click(function (e) {
            e.preventDefault();

            jQuery(this).tab('show');
        });

        slider.slider({
            range : 'min',
            min   : parseInt(slider.data('min')),
            max   : parseInt(slider.data('max')),
            value : parseInt(itemCount.val(), 10),
            slide : function (event, ui) {
                itemCount.val(parseInt(ui.value, 10));
            }
        });


        form.on('keyup', 'input[name=url]', function() {
            var value = jQuery.trim(jQuery(this).val());
            var button = form.find('#testRssRequest');

            if (value.length > 0) {
                button.removeClass('disabled');
            } else {
                button.addClass('disabled');
            }
        });

        form.on('click', '#testRssRequest', function() {
            if (jQuery(this).hasClass('disabled')) {
                return false;
            }

            var loading = '<div class="loading"></div>';
            var data = getWidgetData();

            jQuery.ajax({
                url: '{/literal}{$widget.url}{literal}',
                data: data.metadata.data,
                dataType: 'text',
                beforeSend: function() {
                    navigation.find('a[href="#widgetSetupTabOutput"]').tab('show');
                    tabOutput.find('pre').hide();
                    tabOutput.find('.content').show().html(loading);
                },
                success: function(data) {
                    tabOutput.find('.content').html(data);
                }
            });

            return true;
        });
    });
    {/literal}
</script>
