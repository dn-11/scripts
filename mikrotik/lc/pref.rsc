if (bgp-large-communities any 4220080300:11010:500) {
 set bgp-local-pref 100;
}
if (bgp-large-communities any 4220080300:11010:400) {
 set bgp-local-pref 200;
}
if (bgp-large-communities any 4220080300:11010:300) {
 set bgp-local-pref 300;
}
if (bgp-large-communities any 4220080300:11010:200) {
 set bgp-local-pref 400;
}
if (bgp-large-communities any 4220080300:11010:100) {
 set bgp-local-pref 500;
}