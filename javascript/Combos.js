function LlenarCombo(c,a,b){for(i=0;i<a.length;i++){select_add(c,a[i],b[i])}}function select_clear(a){var b=a.length;for(i=0;i<b;i++){a.remove(0)}}function select_add(e,a,c){var d=document.createElement("option");d.text=a;d.value=c;try{e.add(d,null)}catch(b){e.add(d)}}function insertOptionBefore(a,e,d){var g=document.getElementById(a);if(g.selectedIndex>=0){var f=document.createElement("option");f.text=e;f.value=d;var c=g.options[g.selectedIndex];try{g.add(f,c)}catch(b){g.add(f,g.selectedIndex)}}}function removeOptionSelected(a){var c=document.getElementById(a);var b;for(b=c.length-1;b>=0;b--){if(c.options[b].selected){c.remove(b)}}}function appendOptionLast(a,d,c){var e=document.createElement("option");e.text=d;e.value=c;var f=document.getElementById(a);try{f.add(e,null)}catch(b){f.add(e)}}function removeOptionLast(a){var b=document.getElementById(a);if(b.length>0){b.remove(b.length-1)}}Array.prototype.contains=function(b){for(var a=0;a<this.length;a++){if(this[a]==b){return true}}return false};
function select_addOptGroup(e,a,c){
    var optgroup=document.createElement("optgroup");
    optgroup.setAttribute("label", a);
    try{
        e.add(optgroup,null)
    }catch(b){
        e.add(d)
    }
}
