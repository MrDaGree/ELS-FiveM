console.log("ELS NUI Loaded.");
var resourceName = "els-fivem"

$(function() {    
    window.addEventListener('message', function(event) {
        if (event.data.type == "els-fivem") {
            resourceName = event.data.resourcename;
        }
    });

    document.onkeyup = function (data) {
        if (!data.ctrlKey) {
            $.post('http://' + resourceName + '/close', JSON.stringify({}));
        }
        if (data.which == 74) {
            if (data.altKey) {
                $.post('http://' + resourceName + '/stage_key_down', JSON.stringify({}));
            }else{
                $.post('http://' + resourceName + '/stage_key_up', JSON.stringify({}));
            }
        }
        
        if (data.which == 75) {
            $.post('http://' + resourceName + '/toggle_SECL', JSON.stringify({}));
        }
        if (data.which == 76) {
            $.post('http://' + resourceName + '/toggle_WRNL', JSON.stringify({}));
        }
        
        if (data.which == 85) {
            if (data.altKey) {
                $.post('http://' + resourceName + '/chgpat_PRML_down', JSON.stringify({}));
            }else{
                $.post('http://' + resourceName + '/chgpat_PRML_up', JSON.stringify({}));
            }
        }
        
        if (data.which == 73) {
            if (data.altKey) {
                $.post('http://' + resourceName + '/chgpat_SECL_down', JSON.stringify({}));
            }else{
                $.post('http://' + resourceName + '/chgpat_SECL_up', JSON.stringify({}));
            }
        }
        
        if (data.which == 79) {
            if (data.altKey) {
                $.post('http://' + resourceName + '/chgpat_WRNL_down', JSON.stringify({}));
            }else{
                $.post('http://' + resourceName + '/chgpat_WRNL_up', JSON.stringify({}));
            }
        }
        
        if (data.which == 221) {
            if (data.altKey) {
                $.post('http://' + resourceName + '/toggle_SCENE', JSON.stringify({}));
            }else{
                $.post('http://' + resourceName + '/toggle_TKDL', JSON.stringify({}));
            }
        }
    };
});