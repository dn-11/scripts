if (not bgp-large-communities includes 4220080300:11003:11111) {
  if (not bgp-large-communities-empty && bgp-large-communities any-regexp "^4220080300:11003:[0-9]+$") {
    if (not bgp-large-communities includes 4220080300:11003:52){
      delete bgp-large-communities regexp "^4220080300:11003:[0-9]+$" ;
      append bgp-large-communities 4220080300:11003:11111;
      append bgp-large-communities 4220080300:11002:11111;
      append bgp-large-communities 4220080300:11001:11111;
      append bgp-large-communities 4220080300:11000:11111;
    }
  }else {
    append bgp-large-communities 4220080300:11003:52;
  }
}

if (not bgp-large-communities includes 4220080300:11002:11111) {
  if (not bgp-large-communities-empty && bgp-large-communities any-regexp "^4220080300:11002:[0-9]+$" ) {
    if (not bgp-large-communities includes 4220080300:11002:156){
      delete bgp-large-communities regexp "^4220080300:11002:[0-9]+$" ;
      append bgp-large-communities 4220080300:11002:11111;
      append bgp-large-communities 4220080300:11001:11111;
      append bgp-large-communities 4220080300:11000:11111;
    }
  }else {
    append bgp-large-communities 4220080300:11002:156;
  }
}

if (not bgp-large-communities includes 4220080300:11001:11111) {
  if (not bgp-large-communities-empty && bgp-large-communities any-regexp "^4220080300:11001:[0-9]+$" ) {
    if (not bgp-large-communities includes 4220080300:11001:42){
      delete bgp-large-communities regexp "^4220080300:11001:[0-9]+$" ;
      append bgp-large-communities 4220080300:11001:11111;
      append bgp-large-communities 4220080300:11000:11111;
    }
  }else{
    append bgp-large-communities 4220080300:11001:42;
  }
}

if (not bgp-large-communities includes 4220080300:11000:11111) {
  if (not bgp-large-communities-empty && bgp-large-communities any-regexp "^4220080300:11000:[0-9]+$" ) {
    if (not bgp-large-communities includes 4220080300:11000:33){
      delete bgp-large-communities regexp "^4220080300:11000:[0-9]+$" ;
      append bgp-large-communities 4220080300:11000:11111;
    }
  }else{
    append bgp-large-communities 4220080300:11000:33;
  }
}