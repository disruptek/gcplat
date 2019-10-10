
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_Oauth2GetCertForOpenIdConnect_588709 = ref object of OpenApiRestCall_588441
proc url_Oauth2GetCertForOpenIdConnect_588711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2GetCertForOpenIdConnect_588710(path: JsonNode; query: JsonNode;
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
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  var valid_588840 = query.getOrDefault("userIp")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "userIp", valid_588840
  var valid_588841 = query.getOrDefault("key")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "key", valid_588841
  var valid_588842 = query.getOrDefault("prettyPrint")
  valid_588842 = validateParameter(valid_588842, JBool, required = false,
                                 default = newJBool(true))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588865: Call_Oauth2GetCertForOpenIdConnect_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_588865.validator(path, query, header, formData, body)
  let scheme = call_588865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588865.url(scheme.get, call_588865.host, call_588865.base,
                         call_588865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588865, url, valid)

proc call*(call_588936: Call_Oauth2GetCertForOpenIdConnect_588709;
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
  var query_588937 = newJObject()
  add(query_588937, "fields", newJString(fields))
  add(query_588937, "quotaUser", newJString(quotaUser))
  add(query_588937, "alt", newJString(alt))
  add(query_588937, "oauth_token", newJString(oauthToken))
  add(query_588937, "userIp", newJString(userIp))
  add(query_588937, "key", newJString(key))
  add(query_588937, "prettyPrint", newJBool(prettyPrint))
  result = call_588936.call(nil, query_588937, nil, nil, nil)

var oauth2GetCertForOpenIdConnect* = Call_Oauth2GetCertForOpenIdConnect_588709(
    name: "oauth2GetCertForOpenIdConnect", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/oauth2/v2/certs",
    validator: validate_Oauth2GetCertForOpenIdConnect_588710, base: "/",
    url: url_Oauth2GetCertForOpenIdConnect_588711, schemes: {Scheme.Https})
type
  Call_Oauth2Tokeninfo_588977 = ref object of OpenApiRestCall_588441
proc url_Oauth2Tokeninfo_588979(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2Tokeninfo_588978(path: JsonNode; query: JsonNode;
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
  var valid_588980 = query.getOrDefault("fields")
  valid_588980 = validateParameter(valid_588980, JString, required = false,
                                 default = nil)
  if valid_588980 != nil:
    section.add "fields", valid_588980
  var valid_588981 = query.getOrDefault("quotaUser")
  valid_588981 = validateParameter(valid_588981, JString, required = false,
                                 default = nil)
  if valid_588981 != nil:
    section.add "quotaUser", valid_588981
  var valid_588982 = query.getOrDefault("alt")
  valid_588982 = validateParameter(valid_588982, JString, required = false,
                                 default = newJString("json"))
  if valid_588982 != nil:
    section.add "alt", valid_588982
  var valid_588983 = query.getOrDefault("oauth_token")
  valid_588983 = validateParameter(valid_588983, JString, required = false,
                                 default = nil)
  if valid_588983 != nil:
    section.add "oauth_token", valid_588983
  var valid_588984 = query.getOrDefault("access_token")
  valid_588984 = validateParameter(valid_588984, JString, required = false,
                                 default = nil)
  if valid_588984 != nil:
    section.add "access_token", valid_588984
  var valid_588985 = query.getOrDefault("userIp")
  valid_588985 = validateParameter(valid_588985, JString, required = false,
                                 default = nil)
  if valid_588985 != nil:
    section.add "userIp", valid_588985
  var valid_588986 = query.getOrDefault("id_token")
  valid_588986 = validateParameter(valid_588986, JString, required = false,
                                 default = nil)
  if valid_588986 != nil:
    section.add "id_token", valid_588986
  var valid_588987 = query.getOrDefault("key")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "key", valid_588987
  var valid_588988 = query.getOrDefault("prettyPrint")
  valid_588988 = validateParameter(valid_588988, JBool, required = false,
                                 default = newJBool(true))
  if valid_588988 != nil:
    section.add "prettyPrint", valid_588988
  var valid_588989 = query.getOrDefault("token_handle")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "token_handle", valid_588989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588990: Call_Oauth2Tokeninfo_588977; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_588990.validator(path, query, header, formData, body)
  let scheme = call_588990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588990.url(scheme.get, call_588990.host, call_588990.base,
                         call_588990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588990, url, valid)

proc call*(call_588991: Call_Oauth2Tokeninfo_588977; fields: string = "";
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
  var query_588992 = newJObject()
  add(query_588992, "fields", newJString(fields))
  add(query_588992, "quotaUser", newJString(quotaUser))
  add(query_588992, "alt", newJString(alt))
  add(query_588992, "oauth_token", newJString(oauthToken))
  add(query_588992, "access_token", newJString(accessToken))
  add(query_588992, "userIp", newJString(userIp))
  add(query_588992, "id_token", newJString(idToken))
  add(query_588992, "key", newJString(key))
  add(query_588992, "prettyPrint", newJBool(prettyPrint))
  add(query_588992, "token_handle", newJString(tokenHandle))
  result = call_588991.call(nil, query_588992, nil, nil, nil)

var oauth2Tokeninfo* = Call_Oauth2Tokeninfo_588977(name: "oauth2Tokeninfo",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/oauth2/v2/tokeninfo", validator: validate_Oauth2Tokeninfo_588978,
    base: "/", url: url_Oauth2Tokeninfo_588979, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoGet_588993 = ref object of OpenApiRestCall_588441
proc url_Oauth2UserinfoGet_588995(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoGet_588994(path: JsonNode; query: JsonNode;
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
  var valid_588996 = query.getOrDefault("fields")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "fields", valid_588996
  var valid_588997 = query.getOrDefault("quotaUser")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "quotaUser", valid_588997
  var valid_588998 = query.getOrDefault("alt")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("json"))
  if valid_588998 != nil:
    section.add "alt", valid_588998
  var valid_588999 = query.getOrDefault("oauth_token")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "oauth_token", valid_588999
  var valid_589000 = query.getOrDefault("userIp")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "userIp", valid_589000
  var valid_589001 = query.getOrDefault("key")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "key", valid_589001
  var valid_589002 = query.getOrDefault("prettyPrint")
  valid_589002 = validateParameter(valid_589002, JBool, required = false,
                                 default = newJBool(true))
  if valid_589002 != nil:
    section.add "prettyPrint", valid_589002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589003: Call_Oauth2UserinfoGet_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_589003.validator(path, query, header, formData, body)
  let scheme = call_589003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589003.url(scheme.get, call_589003.host, call_589003.base,
                         call_589003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589003, url, valid)

proc call*(call_589004: Call_Oauth2UserinfoGet_588993; fields: string = "";
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
  var query_589005 = newJObject()
  add(query_589005, "fields", newJString(fields))
  add(query_589005, "quotaUser", newJString(quotaUser))
  add(query_589005, "alt", newJString(alt))
  add(query_589005, "oauth_token", newJString(oauthToken))
  add(query_589005, "userIp", newJString(userIp))
  add(query_589005, "key", newJString(key))
  add(query_589005, "prettyPrint", newJBool(prettyPrint))
  result = call_589004.call(nil, query_589005, nil, nil, nil)

var oauth2UserinfoGet* = Call_Oauth2UserinfoGet_588993(name: "oauth2UserinfoGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/oauth2/v2/userinfo", validator: validate_Oauth2UserinfoGet_588994,
    base: "/", url: url_Oauth2UserinfoGet_588995, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoV2MeGet_589006 = ref object of OpenApiRestCall_588441
proc url_Oauth2UserinfoV2MeGet_589008(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoV2MeGet_589007(path: JsonNode; query: JsonNode;
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
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("userIp")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "userIp", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  var valid_589015 = query.getOrDefault("prettyPrint")
  valid_589015 = validateParameter(valid_589015, JBool, required = false,
                                 default = newJBool(true))
  if valid_589015 != nil:
    section.add "prettyPrint", valid_589015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589016: Call_Oauth2UserinfoV2MeGet_589006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_589016.validator(path, query, header, formData, body)
  let scheme = call_589016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589016.url(scheme.get, call_589016.host, call_589016.base,
                         call_589016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589016, url, valid)

proc call*(call_589017: Call_Oauth2UserinfoV2MeGet_589006; fields: string = "";
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
  var query_589018 = newJObject()
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "userIp", newJString(userIp))
  add(query_589018, "key", newJString(key))
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  result = call_589017.call(nil, query_589018, nil, nil, nil)

var oauth2UserinfoV2MeGet* = Call_Oauth2UserinfoV2MeGet_589006(
    name: "oauth2UserinfoV2MeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/userinfo/v2/me",
    validator: validate_Oauth2UserinfoV2MeGet_589007, base: "/",
    url: url_Oauth2UserinfoV2MeGet_589008, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
