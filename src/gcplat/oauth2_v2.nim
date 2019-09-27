
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Google OAuth2
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Obtains end-user authorization grants for use with other Google APIs.
## 
## https://developers.google.com/accounts/docs/OAuth2
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "oauth2"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Oauth2GetCertForOpenIdConnect_593676 = ref object of OpenApiRestCall_593408
proc url_Oauth2GetCertForOpenIdConnect_593678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Oauth2GetCertForOpenIdConnect_593677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593790 = query.getOrDefault("fields")
  valid_593790 = validateParameter(valid_593790, JString, required = false,
                                 default = nil)
  if valid_593790 != nil:
    section.add "fields", valid_593790
  var valid_593791 = query.getOrDefault("quotaUser")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "quotaUser", valid_593791
  var valid_593805 = query.getOrDefault("alt")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = newJString("json"))
  if valid_593805 != nil:
    section.add "alt", valid_593805
  var valid_593806 = query.getOrDefault("oauth_token")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "oauth_token", valid_593806
  var valid_593807 = query.getOrDefault("userIp")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "userIp", valid_593807
  var valid_593808 = query.getOrDefault("key")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "key", valid_593808
  var valid_593809 = query.getOrDefault("prettyPrint")
  valid_593809 = validateParameter(valid_593809, JBool, required = false,
                                 default = newJBool(true))
  if valid_593809 != nil:
    section.add "prettyPrint", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593832: Call_Oauth2GetCertForOpenIdConnect_593676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_Oauth2GetCertForOpenIdConnect_593676;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## oauth2GetCertForOpenIdConnect
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593904 = newJObject()
  add(query_593904, "fields", newJString(fields))
  add(query_593904, "quotaUser", newJString(quotaUser))
  add(query_593904, "alt", newJString(alt))
  add(query_593904, "oauth_token", newJString(oauthToken))
  add(query_593904, "userIp", newJString(userIp))
  add(query_593904, "key", newJString(key))
  add(query_593904, "prettyPrint", newJBool(prettyPrint))
  result = call_593903.call(nil, query_593904, nil, nil, nil)

var oauth2GetCertForOpenIdConnect* = Call_Oauth2GetCertForOpenIdConnect_593676(
    name: "oauth2GetCertForOpenIdConnect", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/oauth2/v2/certs",
    validator: validate_Oauth2GetCertForOpenIdConnect_593677, base: "/",
    url: url_Oauth2GetCertForOpenIdConnect_593678, schemes: {Scheme.Https})
type
  Call_Oauth2Tokeninfo_593944 = ref object of OpenApiRestCall_593408
proc url_Oauth2Tokeninfo_593946(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Oauth2Tokeninfo_593945(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   access_token: JString
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   id_token: JString
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   token_handle: JString
  section = newJObject()
  var valid_593947 = query.getOrDefault("fields")
  valid_593947 = validateParameter(valid_593947, JString, required = false,
                                 default = nil)
  if valid_593947 != nil:
    section.add "fields", valid_593947
  var valid_593948 = query.getOrDefault("quotaUser")
  valid_593948 = validateParameter(valid_593948, JString, required = false,
                                 default = nil)
  if valid_593948 != nil:
    section.add "quotaUser", valid_593948
  var valid_593949 = query.getOrDefault("alt")
  valid_593949 = validateParameter(valid_593949, JString, required = false,
                                 default = newJString("json"))
  if valid_593949 != nil:
    section.add "alt", valid_593949
  var valid_593950 = query.getOrDefault("oauth_token")
  valid_593950 = validateParameter(valid_593950, JString, required = false,
                                 default = nil)
  if valid_593950 != nil:
    section.add "oauth_token", valid_593950
  var valid_593951 = query.getOrDefault("access_token")
  valid_593951 = validateParameter(valid_593951, JString, required = false,
                                 default = nil)
  if valid_593951 != nil:
    section.add "access_token", valid_593951
  var valid_593952 = query.getOrDefault("userIp")
  valid_593952 = validateParameter(valid_593952, JString, required = false,
                                 default = nil)
  if valid_593952 != nil:
    section.add "userIp", valid_593952
  var valid_593953 = query.getOrDefault("id_token")
  valid_593953 = validateParameter(valid_593953, JString, required = false,
                                 default = nil)
  if valid_593953 != nil:
    section.add "id_token", valid_593953
  var valid_593954 = query.getOrDefault("key")
  valid_593954 = validateParameter(valid_593954, JString, required = false,
                                 default = nil)
  if valid_593954 != nil:
    section.add "key", valid_593954
  var valid_593955 = query.getOrDefault("prettyPrint")
  valid_593955 = validateParameter(valid_593955, JBool, required = false,
                                 default = newJBool(true))
  if valid_593955 != nil:
    section.add "prettyPrint", valid_593955
  var valid_593956 = query.getOrDefault("token_handle")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "token_handle", valid_593956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593957: Call_Oauth2Tokeninfo_593944; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_Oauth2Tokeninfo_593944; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          accessToken: string = ""; userIp: string = ""; idToken: string = "";
          key: string = ""; prettyPrint: bool = true; tokenHandle: string = ""): Recallable =
  ## oauth2Tokeninfo
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accessToken: string
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   idToken: string
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   tokenHandle: string
  var query_593959 = newJObject()
  add(query_593959, "fields", newJString(fields))
  add(query_593959, "quotaUser", newJString(quotaUser))
  add(query_593959, "alt", newJString(alt))
  add(query_593959, "oauth_token", newJString(oauthToken))
  add(query_593959, "access_token", newJString(accessToken))
  add(query_593959, "userIp", newJString(userIp))
  add(query_593959, "id_token", newJString(idToken))
  add(query_593959, "key", newJString(key))
  add(query_593959, "prettyPrint", newJBool(prettyPrint))
  add(query_593959, "token_handle", newJString(tokenHandle))
  result = call_593958.call(nil, query_593959, nil, nil, nil)

var oauth2Tokeninfo* = Call_Oauth2Tokeninfo_593944(name: "oauth2Tokeninfo",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/oauth2/v2/tokeninfo", validator: validate_Oauth2Tokeninfo_593945,
    base: "/", url: url_Oauth2Tokeninfo_593946, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoGet_593960 = ref object of OpenApiRestCall_593408
proc url_Oauth2UserinfoGet_593962(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoGet_593961(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593963 = query.getOrDefault("fields")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "fields", valid_593963
  var valid_593964 = query.getOrDefault("quotaUser")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "quotaUser", valid_593964
  var valid_593965 = query.getOrDefault("alt")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = newJString("json"))
  if valid_593965 != nil:
    section.add "alt", valid_593965
  var valid_593966 = query.getOrDefault("oauth_token")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "oauth_token", valid_593966
  var valid_593967 = query.getOrDefault("userIp")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "userIp", valid_593967
  var valid_593968 = query.getOrDefault("key")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "key", valid_593968
  var valid_593969 = query.getOrDefault("prettyPrint")
  valid_593969 = validateParameter(valid_593969, JBool, required = false,
                                 default = newJBool(true))
  if valid_593969 != nil:
    section.add "prettyPrint", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_Oauth2UserinfoGet_593960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_Oauth2UserinfoGet_593960; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## oauth2UserinfoGet
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593972 = newJObject()
  add(query_593972, "fields", newJString(fields))
  add(query_593972, "quotaUser", newJString(quotaUser))
  add(query_593972, "alt", newJString(alt))
  add(query_593972, "oauth_token", newJString(oauthToken))
  add(query_593972, "userIp", newJString(userIp))
  add(query_593972, "key", newJString(key))
  add(query_593972, "prettyPrint", newJBool(prettyPrint))
  result = call_593971.call(nil, query_593972, nil, nil, nil)

var oauth2UserinfoGet* = Call_Oauth2UserinfoGet_593960(name: "oauth2UserinfoGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/oauth2/v2/userinfo", validator: validate_Oauth2UserinfoGet_593961,
    base: "/", url: url_Oauth2UserinfoGet_593962, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoV2MeGet_593973 = ref object of OpenApiRestCall_593408
proc url_Oauth2UserinfoV2MeGet_593975(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoV2MeGet_593974(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593976 = query.getOrDefault("fields")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "fields", valid_593976
  var valid_593977 = query.getOrDefault("quotaUser")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "quotaUser", valid_593977
  var valid_593978 = query.getOrDefault("alt")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("json"))
  if valid_593978 != nil:
    section.add "alt", valid_593978
  var valid_593979 = query.getOrDefault("oauth_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "oauth_token", valid_593979
  var valid_593980 = query.getOrDefault("userIp")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "userIp", valid_593980
  var valid_593981 = query.getOrDefault("key")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "key", valid_593981
  var valid_593982 = query.getOrDefault("prettyPrint")
  valid_593982 = validateParameter(valid_593982, JBool, required = false,
                                 default = newJBool(true))
  if valid_593982 != nil:
    section.add "prettyPrint", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_Oauth2UserinfoV2MeGet_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_Oauth2UserinfoV2MeGet_593973; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## oauth2UserinfoV2MeGet
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593985 = newJObject()
  add(query_593985, "fields", newJString(fields))
  add(query_593985, "quotaUser", newJString(quotaUser))
  add(query_593985, "alt", newJString(alt))
  add(query_593985, "oauth_token", newJString(oauthToken))
  add(query_593985, "userIp", newJString(userIp))
  add(query_593985, "key", newJString(key))
  add(query_593985, "prettyPrint", newJBool(prettyPrint))
  result = call_593984.call(nil, query_593985, nil, nil, nil)

var oauth2UserinfoV2MeGet* = Call_Oauth2UserinfoV2MeGet_593973(
    name: "oauth2UserinfoV2MeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/userinfo/v2/me",
    validator: validate_Oauth2UserinfoV2MeGet_593974, base: "/",
    url: url_Oauth2UserinfoV2MeGet_593975, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
