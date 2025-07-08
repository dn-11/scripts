if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11003:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11003:([^5][0-9]|[0-9][^2]|[0-9]|[0-9][0-9][0-9]+)$"){
  if (not bgp-large-communities any-regexp "^4220080300:11010:500$") {
    delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
    append bgp-large-communities 4220080300:11010:500;
  }
}else{
  if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11002:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11002:([^1][0-9][0-9]|[0-9][^5][0-9]|[0-9][0-9][^6]|[0-9]|[0-9][0-9]|[0-9][0-9][0-9][0-9]+)$"){
    if (not bgp-large-communities any-regexp "^4220080300:11010:(400|500)$") {
      delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
      append bgp-large-communities 4220080300:11010:400;
    }
  }else{
    if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11001:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11001:([^4][0-9]|[0-9][^2]|[0-9]|[0-9][0-9][0-9]+)$"){
      if (not bgp-large-communities any-regexp "^4220080300:11010:(300|400|500)$") {
        delete bgp-large-communities regexp ^4220080300:11010:[0-9]+$;
        append bgp-large-communities 4220080300:11010:300;
      }
    }else{
      if (bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11000:11111$" || bgp-large-communities any-regexp "^(422008|421111)[0-9]+:11000:([^3][0-9]|[0-9][^3]|[0-9]|[0-9][0-9][0-9]+)$"){
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

if (bgp-large-communities-empty) {
  append bgp-large-communities 4220080300:11010:100;
}
