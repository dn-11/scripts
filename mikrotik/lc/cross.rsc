if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11003:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11003:(?!52$)[0-9]+$"){
  if (not bgp-large-communities any 4220080300:11010:500) {
    delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
    append bgp-large-communities 4220080300:11010:500;
  }
}else{
  if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11002:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11002:(?!156$)[0-9]+$"){
    if (not bgp-large-communities any-regexp "^4220080300:11010:(400|500)$") {
      delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
      append bgp-large-communities 4220080300:11010:400;
    }
  }else{
    if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11001:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11001:(?!42$)[0-9]+$"){
      if (not bgp-large-communities any-regexp "^4220080300:11010:(300|400|500)$") {
        delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
        append bgp-large-communities 4220080300:11010:300;
      }
    }else{
      if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11000:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11000:(?!33$)[0-9]+$"){
        if (not bgp-large-communities any-regexp "^4220080300:11010:(200|300|400|500)$") {
          delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
          append bgp-large-communities 4220080300:11010:200;
        }
      }else{
        if (not bgp-large-communities any-regexp "^4220080300:11010:(100|200|300|400|500)$") {
          delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
          append bgp-large-communities 4220080300:11010:100;
        }
      }
    }
  }
}