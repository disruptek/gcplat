
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Oauth2GetCertForOpenIdConnect_579676 = ref object of OpenApiRestCall_579408
proc url_Oauth2GetCertForOpenIdConnect_579678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2GetCertForOpenIdConnect_579677(path: JsonNode; query: JsonNode;
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
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("oauth_token")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "oauth_token", valid_579806
  var valid_579807 = query.getOrDefault("userIp")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "userIp", valid_579807
  var valid_579808 = query.getOrDefault("key")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "key", valid_579808
  var valid_579809 = query.getOrDefault("prettyPrint")
  valid_579809 = validateParameter(valid_579809, JBool, required = false,
                                 default = newJBool(true))
  if valid_579809 != nil:
    section.add "prettyPrint", valid_579809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579832: Call_Oauth2GetCertForOpenIdConnect_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579832.validator(path, query, header, formData, body)
  let scheme = call_579832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579832.url(scheme.get, call_579832.host, call_579832.base,
                         call_579832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579832, url, valid)

proc call*(call_579903: Call_Oauth2GetCertForOpenIdConnect_579676;
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
  var query_579904 = newJObject()
  add(query_579904, "fields", newJString(fields))
  add(query_579904, "quotaUser", newJString(quotaUser))
  add(query_579904, "alt", newJString(alt))
  add(query_579904, "oauth_token", newJString(oauthToken))
  add(query_579904, "userIp", newJString(userIp))
  add(query_579904, "key", newJString(key))
  add(query_579904, "prettyPrint", newJBool(prettyPrint))
  result = call_579903.call(nil, query_579904, nil, nil, nil)

var oauth2GetCertForOpenIdConnect* = Call_Oauth2GetCertForOpenIdConnect_579676(
    name: "oauth2GetCertForOpenIdConnect", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/oauth2/v2/certs",
    validator: validate_Oauth2GetCertForOpenIdConnect_579677, base: "/",
    url: url_Oauth2GetCertForOpenIdConnect_579678, schemes: {Scheme.Https})
type
  Call_Oauth2Tokeninfo_579944 = ref object of OpenApiRestCall_579408
proc url_Oauth2Tokeninfo_579946(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2Tokeninfo_579945(path: JsonNode; query: JsonNode;
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
  var valid_579947 = query.getOrDefault("fields")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "fields", valid_579947
  var valid_579948 = query.getOrDefault("quotaUser")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "quotaUser", valid_579948
  var valid_579949 = query.getOrDefault("alt")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = newJString("json"))
  if valid_579949 != nil:
    section.add "alt", valid_579949
  var valid_579950 = query.getOrDefault("oauth_token")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "oauth_token", valid_579950
  var valid_579951 = query.getOrDefault("access_token")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "access_token", valid_579951
  var valid_579952 = query.getOrDefault("userIp")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "userIp", valid_579952
  var valid_579953 = query.getOrDefault("id_token")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "id_token", valid_579953
  var valid_579954 = query.getOrDefault("key")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "key", valid_579954
  var valid_579955 = query.getOrDefault("prettyPrint")
  valid_579955 = validateParameter(valid_579955, JBool, required = false,
                                 default = newJBool(true))
  if valid_579955 != nil:
    section.add "prettyPrint", valid_579955
  var valid_579956 = query.getOrDefault("token_handle")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "token_handle", valid_579956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579957: Call_Oauth2Tokeninfo_579944; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_Oauth2Tokeninfo_579944; fields: string = "";
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
  var query_579959 = newJObject()
  add(query_579959, "fields", newJString(fields))
  add(query_579959, "quotaUser", newJString(quotaUser))
  add(query_579959, "alt", newJString(alt))
  add(query_579959, "oauth_token", newJString(oauthToken))
  add(query_579959, "access_token", newJString(accessToken))
  add(query_579959, "userIp", newJString(userIp))
  add(query_579959, "id_token", newJString(idToken))
  add(query_579959, "key", newJString(key))
  add(query_579959, "prettyPrint", newJBool(prettyPrint))
  add(query_579959, "token_handle", newJString(tokenHandle))
  result = call_579958.call(nil, query_579959, nil, nil, nil)

var oauth2Tokeninfo* = Call_Oauth2Tokeninfo_579944(name: "oauth2Tokeninfo",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/oauth2/v2/tokeninfo", validator: validate_Oauth2Tokeninfo_579945,
    base: "/", url: url_Oauth2Tokeninfo_579946, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoGet_579960 = ref object of OpenApiRestCall_579408
proc url_Oauth2UserinfoGet_579962(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoGet_579961(path: JsonNode; query: JsonNode;
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
  var valid_579963 = query.getOrDefault("fields")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "fields", valid_579963
  var valid_579964 = query.getOrDefault("quotaUser")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "quotaUser", valid_579964
  var valid_579965 = query.getOrDefault("alt")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("json"))
  if valid_579965 != nil:
    section.add "alt", valid_579965
  var valid_579966 = query.getOrDefault("oauth_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "oauth_token", valid_579966
  var valid_579967 = query.getOrDefault("userIp")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "userIp", valid_579967
  var valid_579968 = query.getOrDefault("key")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "key", valid_579968
  var valid_579969 = query.getOrDefault("prettyPrint")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(true))
  if valid_579969 != nil:
    section.add "prettyPrint", valid_579969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579970: Call_Oauth2UserinfoGet_579960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579970.validator(path, query, header, formData, body)
  let scheme = call_579970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579970.url(scheme.get, call_579970.host, call_579970.base,
                         call_579970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579970, url, valid)

proc call*(call_579971: Call_Oauth2UserinfoGet_579960; fields: string = "";
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
  var query_579972 = newJObject()
  add(query_579972, "fields", newJString(fields))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(query_579972, "userIp", newJString(userIp))
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  result = call_579971.call(nil, query_579972, nil, nil, nil)

var oauth2UserinfoGet* = Call_Oauth2UserinfoGet_579960(name: "oauth2UserinfoGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/oauth2/v2/userinfo", validator: validate_Oauth2UserinfoGet_579961,
    base: "/", url: url_Oauth2UserinfoGet_579962, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoV2MeGet_579973 = ref object of OpenApiRestCall_579408
proc url_Oauth2UserinfoV2MeGet_579975(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoV2MeGet_579974(path: JsonNode; query: JsonNode;
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
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("userIp")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "userIp", valid_579980
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_Oauth2UserinfoV2MeGet_579973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_Oauth2UserinfoV2MeGet_579973; fields: string = "";
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
  var query_579985 = newJObject()
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "userIp", newJString(userIp))
  add(query_579985, "key", newJString(key))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  result = call_579984.call(nil, query_579985, nil, nil, nil)

var oauth2UserinfoV2MeGet* = Call_Oauth2UserinfoV2MeGet_579973(
    name: "oauth2UserinfoV2MeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/userinfo/v2/me",
    validator: validate_Oauth2UserinfoV2MeGet_579974, base: "/",
    url: url_Oauth2UserinfoV2MeGet_579975, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
