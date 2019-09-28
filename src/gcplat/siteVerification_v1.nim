
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Site Verification
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Verifies ownership of websites or domains with Google.
## 
## https://developers.google.com/site-verification/
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
  gcpServiceName = "siteVerification"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SiteVerificationWebResourceGetToken_579676 = ref object of OpenApiRestCall_579408
proc url_SiteVerificationWebResourceGetToken_579678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceGetToken_579677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a verification token for placing on a website or domain.
  ## 
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
                                 default = newJBool(false))
  if valid_579809 != nil:
    section.add "prettyPrint", valid_579809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579833: Call_SiteVerificationWebResourceGetToken_579676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a verification token for placing on a website or domain.
  ## 
  let valid = call_579833.validator(path, query, header, formData, body)
  let scheme = call_579833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579833.url(scheme.get, call_579833.host, call_579833.base,
                         call_579833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579833, url, valid)

proc call*(call_579904: Call_SiteVerificationWebResourceGetToken_579676;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## siteVerificationWebResourceGetToken
  ## Get a verification token for placing on a website or domain.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579905 = newJObject()
  var body_579907 = newJObject()
  add(query_579905, "fields", newJString(fields))
  add(query_579905, "quotaUser", newJString(quotaUser))
  add(query_579905, "alt", newJString(alt))
  add(query_579905, "oauth_token", newJString(oauthToken))
  add(query_579905, "userIp", newJString(userIp))
  add(query_579905, "key", newJString(key))
  if body != nil:
    body_579907 = body
  add(query_579905, "prettyPrint", newJBool(prettyPrint))
  result = call_579904.call(nil, query_579905, nil, nil, body_579907)

var siteVerificationWebResourceGetToken* = Call_SiteVerificationWebResourceGetToken_579676(
    name: "siteVerificationWebResourceGetToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/token",
    validator: validate_SiteVerificationWebResourceGetToken_579677,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceGetToken_579678,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceInsert_579959 = ref object of OpenApiRestCall_579408
proc url_SiteVerificationWebResourceInsert_579961(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceInsert_579960(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attempt verification of a website or domain.
  ## 
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
  ##   verificationMethod: JString (required)
  ##                     : The method to use for verifying a site or domain.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579962 = query.getOrDefault("fields")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "fields", valid_579962
  var valid_579963 = query.getOrDefault("quotaUser")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "quotaUser", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("oauth_token")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "oauth_token", valid_579965
  var valid_579966 = query.getOrDefault("userIp")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "userIp", valid_579966
  var valid_579967 = query.getOrDefault("key")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "key", valid_579967
  assert query != nil, "query argument is necessary due to required `verificationMethod` field"
  var valid_579968 = query.getOrDefault("verificationMethod")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "verificationMethod", valid_579968
  var valid_579969 = query.getOrDefault("prettyPrint")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(false))
  if valid_579969 != nil:
    section.add "prettyPrint", valid_579969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579971: Call_SiteVerificationWebResourceInsert_579959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attempt verification of a website or domain.
  ## 
  let valid = call_579971.validator(path, query, header, formData, body)
  let scheme = call_579971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579971.url(scheme.get, call_579971.host, call_579971.base,
                         call_579971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579971, url, valid)

proc call*(call_579972: Call_SiteVerificationWebResourceInsert_579959;
          verificationMethod: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## siteVerificationWebResourceInsert
  ## Attempt verification of a website or domain.
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
  ##   verificationMethod: string (required)
  ##                     : The method to use for verifying a site or domain.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579973 = newJObject()
  var body_579974 = newJObject()
  add(query_579973, "fields", newJString(fields))
  add(query_579973, "quotaUser", newJString(quotaUser))
  add(query_579973, "alt", newJString(alt))
  add(query_579973, "oauth_token", newJString(oauthToken))
  add(query_579973, "userIp", newJString(userIp))
  add(query_579973, "key", newJString(key))
  add(query_579973, "verificationMethod", newJString(verificationMethod))
  if body != nil:
    body_579974 = body
  add(query_579973, "prettyPrint", newJBool(prettyPrint))
  result = call_579972.call(nil, query_579973, nil, nil, body_579974)

var siteVerificationWebResourceInsert* = Call_SiteVerificationWebResourceInsert_579959(
    name: "siteVerificationWebResourceInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/webResource",
    validator: validate_SiteVerificationWebResourceInsert_579960,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceInsert_579961,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceList_579946 = ref object of OpenApiRestCall_579408
proc url_SiteVerificationWebResourceList_579948(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceList_579947(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of your verified websites and domains.
  ## 
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
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
  var valid_579950 = query.getOrDefault("quotaUser")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "quotaUser", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("userIp")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "userIp", valid_579953
  var valid_579954 = query.getOrDefault("key")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "key", valid_579954
  var valid_579955 = query.getOrDefault("prettyPrint")
  valid_579955 = validateParameter(valid_579955, JBool, required = false,
                                 default = newJBool(false))
  if valid_579955 != nil:
    section.add "prettyPrint", valid_579955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579956: Call_SiteVerificationWebResourceList_579946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of your verified websites and domains.
  ## 
  let valid = call_579956.validator(path, query, header, formData, body)
  let scheme = call_579956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579956.url(scheme.get, call_579956.host, call_579956.base,
                         call_579956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579956, url, valid)

proc call*(call_579957: Call_SiteVerificationWebResourceList_579946;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## siteVerificationWebResourceList
  ## Get the list of your verified websites and domains.
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
  var query_579958 = newJObject()
  add(query_579958, "fields", newJString(fields))
  add(query_579958, "quotaUser", newJString(quotaUser))
  add(query_579958, "alt", newJString(alt))
  add(query_579958, "oauth_token", newJString(oauthToken))
  add(query_579958, "userIp", newJString(userIp))
  add(query_579958, "key", newJString(key))
  add(query_579958, "prettyPrint", newJBool(prettyPrint))
  result = call_579957.call(nil, query_579958, nil, nil, nil)

var siteVerificationWebResourceList* = Call_SiteVerificationWebResourceList_579946(
    name: "siteVerificationWebResourceList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/webResource",
    validator: validate_SiteVerificationWebResourceList_579947,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceList_579948,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceUpdate_580004 = ref object of OpenApiRestCall_579408
proc url_SiteVerificationWebResourceUpdate_580006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourceUpdate_580005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify the list of owners for your website or domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id of a verified site or domain.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580007 = path.getOrDefault("id")
  valid_580007 = validateParameter(valid_580007, JString, required = true,
                                 default = nil)
  if valid_580007 != nil:
    section.add "id", valid_580007
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
  var valid_580008 = query.getOrDefault("fields")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "fields", valid_580008
  var valid_580009 = query.getOrDefault("quotaUser")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "quotaUser", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("userIp")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "userIp", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(false))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580016: Call_SiteVerificationWebResourceUpdate_580004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the list of owners for your website or domain.
  ## 
  let valid = call_580016.validator(path, query, header, formData, body)
  let scheme = call_580016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580016.url(scheme.get, call_580016.host, call_580016.base,
                         call_580016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580016, url, valid)

proc call*(call_580017: Call_SiteVerificationWebResourceUpdate_580004; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## siteVerificationWebResourceUpdate
  ## Modify the list of owners for your website or domain.
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
  ##   id: string (required)
  ##     : The id of a verified site or domain.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580018 = newJObject()
  var query_580019 = newJObject()
  var body_580020 = newJObject()
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "userIp", newJString(userIp))
  add(path_580018, "id", newJString(id))
  add(query_580019, "key", newJString(key))
  if body != nil:
    body_580020 = body
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580017.call(path_580018, query_580019, nil, nil, body_580020)

var siteVerificationWebResourceUpdate* = Call_SiteVerificationWebResourceUpdate_580004(
    name: "siteVerificationWebResourceUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceUpdate_580005,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceUpdate_580006,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceGet_579975 = ref object of OpenApiRestCall_579408
proc url_SiteVerificationWebResourceGet_579977(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourceGet_579976(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the most current data for a website or domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id of a verified site or domain.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579992 = path.getOrDefault("id")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "id", valid_579992
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
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("oauth_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "oauth_token", valid_579996
  var valid_579997 = query.getOrDefault("userIp")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "userIp", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(false))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580000: Call_SiteVerificationWebResourceGet_579975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the most current data for a website or domain.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_SiteVerificationWebResourceGet_579975; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## siteVerificationWebResourceGet
  ## Get the most current data for a website or domain.
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
  ##   id: string (required)
  ##     : The id of a verified site or domain.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580002 = newJObject()
  var query_580003 = newJObject()
  add(query_580003, "fields", newJString(fields))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "userIp", newJString(userIp))
  add(path_580002, "id", newJString(id))
  add(query_580003, "key", newJString(key))
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  result = call_580001.call(path_580002, query_580003, nil, nil, nil)

var siteVerificationWebResourceGet* = Call_SiteVerificationWebResourceGet_579975(
    name: "siteVerificationWebResourceGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceGet_579976,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceGet_579977,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourcePatch_580036 = ref object of OpenApiRestCall_579408
proc url_SiteVerificationWebResourcePatch_580038(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourcePatch_580037(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify the list of owners for your website or domain. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id of a verified site or domain.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580039 = path.getOrDefault("id")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "id", valid_580039
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
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("oauth_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "oauth_token", valid_580043
  var valid_580044 = query.getOrDefault("userIp")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "userIp", valid_580044
  var valid_580045 = query.getOrDefault("key")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "key", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(false))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580048: Call_SiteVerificationWebResourcePatch_580036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the list of owners for your website or domain. This method supports patch semantics.
  ## 
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_SiteVerificationWebResourcePatch_580036; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## siteVerificationWebResourcePatch
  ## Modify the list of owners for your website or domain. This method supports patch semantics.
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
  ##   id: string (required)
  ##     : The id of a verified site or domain.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  var body_580052 = newJObject()
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "userIp", newJString(userIp))
  add(path_580050, "id", newJString(id))
  add(query_580051, "key", newJString(key))
  if body != nil:
    body_580052 = body
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  result = call_580049.call(path_580050, query_580051, nil, nil, body_580052)

var siteVerificationWebResourcePatch* = Call_SiteVerificationWebResourcePatch_580036(
    name: "siteVerificationWebResourcePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourcePatch_580037,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourcePatch_580038,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceDelete_580021 = ref object of OpenApiRestCall_579408
proc url_SiteVerificationWebResourceDelete_580023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourceDelete_580022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Relinquish ownership of a website or domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id of a verified site or domain.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580024 = path.getOrDefault("id")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "id", valid_580024
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
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("userIp")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "userIp", valid_580029
  var valid_580030 = query.getOrDefault("key")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "key", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(false))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580032: Call_SiteVerificationWebResourceDelete_580021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Relinquish ownership of a website or domain.
  ## 
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_SiteVerificationWebResourceDelete_580021; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## siteVerificationWebResourceDelete
  ## Relinquish ownership of a website or domain.
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
  ##   id: string (required)
  ##     : The id of a verified site or domain.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580034 = newJObject()
  var query_580035 = newJObject()
  add(query_580035, "fields", newJString(fields))
  add(query_580035, "quotaUser", newJString(quotaUser))
  add(query_580035, "alt", newJString(alt))
  add(query_580035, "oauth_token", newJString(oauthToken))
  add(query_580035, "userIp", newJString(userIp))
  add(path_580034, "id", newJString(id))
  add(query_580035, "key", newJString(key))
  add(query_580035, "prettyPrint", newJBool(prettyPrint))
  result = call_580033.call(path_580034, query_580035, nil, nil, nil)

var siteVerificationWebResourceDelete* = Call_SiteVerificationWebResourceDelete_580021(
    name: "siteVerificationWebResourceDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceDelete_580022,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceDelete_580023,
    schemes: {Scheme.Https})
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
