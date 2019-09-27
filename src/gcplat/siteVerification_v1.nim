
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "siteVerification"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SiteVerificationWebResourceGetToken_593676 = ref object of OpenApiRestCall_593408
proc url_SiteVerificationWebResourceGetToken_593678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceGetToken_593677(path: JsonNode;
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
                                 default = newJBool(false))
  if valid_593809 != nil:
    section.add "prettyPrint", valid_593809
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

proc call*(call_593833: Call_SiteVerificationWebResourceGetToken_593676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a verification token for placing on a website or domain.
  ## 
  let valid = call_593833.validator(path, query, header, formData, body)
  let scheme = call_593833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593833.url(scheme.get, call_593833.host, call_593833.base,
                         call_593833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593833, url, valid)

proc call*(call_593904: Call_SiteVerificationWebResourceGetToken_593676;
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
  var query_593905 = newJObject()
  var body_593907 = newJObject()
  add(query_593905, "fields", newJString(fields))
  add(query_593905, "quotaUser", newJString(quotaUser))
  add(query_593905, "alt", newJString(alt))
  add(query_593905, "oauth_token", newJString(oauthToken))
  add(query_593905, "userIp", newJString(userIp))
  add(query_593905, "key", newJString(key))
  if body != nil:
    body_593907 = body
  add(query_593905, "prettyPrint", newJBool(prettyPrint))
  result = call_593904.call(nil, query_593905, nil, nil, body_593907)

var siteVerificationWebResourceGetToken* = Call_SiteVerificationWebResourceGetToken_593676(
    name: "siteVerificationWebResourceGetToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/token",
    validator: validate_SiteVerificationWebResourceGetToken_593677,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceGetToken_593678,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceInsert_593959 = ref object of OpenApiRestCall_593408
proc url_SiteVerificationWebResourceInsert_593961(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceInsert_593960(path: JsonNode;
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
  var valid_593962 = query.getOrDefault("fields")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "fields", valid_593962
  var valid_593963 = query.getOrDefault("quotaUser")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "quotaUser", valid_593963
  var valid_593964 = query.getOrDefault("alt")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = newJString("json"))
  if valid_593964 != nil:
    section.add "alt", valid_593964
  var valid_593965 = query.getOrDefault("oauth_token")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "oauth_token", valid_593965
  var valid_593966 = query.getOrDefault("userIp")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "userIp", valid_593966
  var valid_593967 = query.getOrDefault("key")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "key", valid_593967
  assert query != nil, "query argument is necessary due to required `verificationMethod` field"
  var valid_593968 = query.getOrDefault("verificationMethod")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "verificationMethod", valid_593968
  var valid_593969 = query.getOrDefault("prettyPrint")
  valid_593969 = validateParameter(valid_593969, JBool, required = false,
                                 default = newJBool(false))
  if valid_593969 != nil:
    section.add "prettyPrint", valid_593969
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

proc call*(call_593971: Call_SiteVerificationWebResourceInsert_593959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attempt verification of a website or domain.
  ## 
  let valid = call_593971.validator(path, query, header, formData, body)
  let scheme = call_593971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593971.url(scheme.get, call_593971.host, call_593971.base,
                         call_593971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593971, url, valid)

proc call*(call_593972: Call_SiteVerificationWebResourceInsert_593959;
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
  var query_593973 = newJObject()
  var body_593974 = newJObject()
  add(query_593973, "fields", newJString(fields))
  add(query_593973, "quotaUser", newJString(quotaUser))
  add(query_593973, "alt", newJString(alt))
  add(query_593973, "oauth_token", newJString(oauthToken))
  add(query_593973, "userIp", newJString(userIp))
  add(query_593973, "key", newJString(key))
  add(query_593973, "verificationMethod", newJString(verificationMethod))
  if body != nil:
    body_593974 = body
  add(query_593973, "prettyPrint", newJBool(prettyPrint))
  result = call_593972.call(nil, query_593973, nil, nil, body_593974)

var siteVerificationWebResourceInsert* = Call_SiteVerificationWebResourceInsert_593959(
    name: "siteVerificationWebResourceInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/webResource",
    validator: validate_SiteVerificationWebResourceInsert_593960,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceInsert_593961,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceList_593946 = ref object of OpenApiRestCall_593408
proc url_SiteVerificationWebResourceList_593948(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceList_593947(path: JsonNode;
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
  var valid_593949 = query.getOrDefault("fields")
  valid_593949 = validateParameter(valid_593949, JString, required = false,
                                 default = nil)
  if valid_593949 != nil:
    section.add "fields", valid_593949
  var valid_593950 = query.getOrDefault("quotaUser")
  valid_593950 = validateParameter(valid_593950, JString, required = false,
                                 default = nil)
  if valid_593950 != nil:
    section.add "quotaUser", valid_593950
  var valid_593951 = query.getOrDefault("alt")
  valid_593951 = validateParameter(valid_593951, JString, required = false,
                                 default = newJString("json"))
  if valid_593951 != nil:
    section.add "alt", valid_593951
  var valid_593952 = query.getOrDefault("oauth_token")
  valid_593952 = validateParameter(valid_593952, JString, required = false,
                                 default = nil)
  if valid_593952 != nil:
    section.add "oauth_token", valid_593952
  var valid_593953 = query.getOrDefault("userIp")
  valid_593953 = validateParameter(valid_593953, JString, required = false,
                                 default = nil)
  if valid_593953 != nil:
    section.add "userIp", valid_593953
  var valid_593954 = query.getOrDefault("key")
  valid_593954 = validateParameter(valid_593954, JString, required = false,
                                 default = nil)
  if valid_593954 != nil:
    section.add "key", valid_593954
  var valid_593955 = query.getOrDefault("prettyPrint")
  valid_593955 = validateParameter(valid_593955, JBool, required = false,
                                 default = newJBool(false))
  if valid_593955 != nil:
    section.add "prettyPrint", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593956: Call_SiteVerificationWebResourceList_593946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of your verified websites and domains.
  ## 
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_SiteVerificationWebResourceList_593946;
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
  var query_593958 = newJObject()
  add(query_593958, "fields", newJString(fields))
  add(query_593958, "quotaUser", newJString(quotaUser))
  add(query_593958, "alt", newJString(alt))
  add(query_593958, "oauth_token", newJString(oauthToken))
  add(query_593958, "userIp", newJString(userIp))
  add(query_593958, "key", newJString(key))
  add(query_593958, "prettyPrint", newJBool(prettyPrint))
  result = call_593957.call(nil, query_593958, nil, nil, nil)

var siteVerificationWebResourceList* = Call_SiteVerificationWebResourceList_593946(
    name: "siteVerificationWebResourceList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/webResource",
    validator: validate_SiteVerificationWebResourceList_593947,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceList_593948,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceUpdate_594004 = ref object of OpenApiRestCall_593408
proc url_SiteVerificationWebResourceUpdate_594006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourceUpdate_594005(path: JsonNode;
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
  var valid_594007 = path.getOrDefault("id")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "id", valid_594007
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
  var valid_594008 = query.getOrDefault("fields")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "fields", valid_594008
  var valid_594009 = query.getOrDefault("quotaUser")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "quotaUser", valid_594009
  var valid_594010 = query.getOrDefault("alt")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("json"))
  if valid_594010 != nil:
    section.add "alt", valid_594010
  var valid_594011 = query.getOrDefault("oauth_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "oauth_token", valid_594011
  var valid_594012 = query.getOrDefault("userIp")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "userIp", valid_594012
  var valid_594013 = query.getOrDefault("key")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "key", valid_594013
  var valid_594014 = query.getOrDefault("prettyPrint")
  valid_594014 = validateParameter(valid_594014, JBool, required = false,
                                 default = newJBool(false))
  if valid_594014 != nil:
    section.add "prettyPrint", valid_594014
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

proc call*(call_594016: Call_SiteVerificationWebResourceUpdate_594004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the list of owners for your website or domain.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_SiteVerificationWebResourceUpdate_594004; id: string;
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
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(query_594019, "fields", newJString(fields))
  add(query_594019, "quotaUser", newJString(quotaUser))
  add(query_594019, "alt", newJString(alt))
  add(query_594019, "oauth_token", newJString(oauthToken))
  add(query_594019, "userIp", newJString(userIp))
  add(path_594018, "id", newJString(id))
  add(query_594019, "key", newJString(key))
  if body != nil:
    body_594020 = body
  add(query_594019, "prettyPrint", newJBool(prettyPrint))
  result = call_594017.call(path_594018, query_594019, nil, nil, body_594020)

var siteVerificationWebResourceUpdate* = Call_SiteVerificationWebResourceUpdate_594004(
    name: "siteVerificationWebResourceUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceUpdate_594005,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceUpdate_594006,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceGet_593975 = ref object of OpenApiRestCall_593408
proc url_SiteVerificationWebResourceGet_593977(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourceGet_593976(path: JsonNode;
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
  var valid_593992 = path.getOrDefault("id")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "id", valid_593992
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
  var valid_593993 = query.getOrDefault("fields")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "fields", valid_593993
  var valid_593994 = query.getOrDefault("quotaUser")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "quotaUser", valid_593994
  var valid_593995 = query.getOrDefault("alt")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("json"))
  if valid_593995 != nil:
    section.add "alt", valid_593995
  var valid_593996 = query.getOrDefault("oauth_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "oauth_token", valid_593996
  var valid_593997 = query.getOrDefault("userIp")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "userIp", valid_593997
  var valid_593998 = query.getOrDefault("key")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "key", valid_593998
  var valid_593999 = query.getOrDefault("prettyPrint")
  valid_593999 = validateParameter(valid_593999, JBool, required = false,
                                 default = newJBool(false))
  if valid_593999 != nil:
    section.add "prettyPrint", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_SiteVerificationWebResourceGet_593975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the most current data for a website or domain.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_SiteVerificationWebResourceGet_593975; id: string;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "fields", newJString(fields))
  add(query_594003, "quotaUser", newJString(quotaUser))
  add(query_594003, "alt", newJString(alt))
  add(query_594003, "oauth_token", newJString(oauthToken))
  add(query_594003, "userIp", newJString(userIp))
  add(path_594002, "id", newJString(id))
  add(query_594003, "key", newJString(key))
  add(query_594003, "prettyPrint", newJBool(prettyPrint))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var siteVerificationWebResourceGet* = Call_SiteVerificationWebResourceGet_593975(
    name: "siteVerificationWebResourceGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceGet_593976,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceGet_593977,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourcePatch_594036 = ref object of OpenApiRestCall_593408
proc url_SiteVerificationWebResourcePatch_594038(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourcePatch_594037(path: JsonNode;
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
  var valid_594039 = path.getOrDefault("id")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "id", valid_594039
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
  var valid_594040 = query.getOrDefault("fields")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "fields", valid_594040
  var valid_594041 = query.getOrDefault("quotaUser")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "quotaUser", valid_594041
  var valid_594042 = query.getOrDefault("alt")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("json"))
  if valid_594042 != nil:
    section.add "alt", valid_594042
  var valid_594043 = query.getOrDefault("oauth_token")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "oauth_token", valid_594043
  var valid_594044 = query.getOrDefault("userIp")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "userIp", valid_594044
  var valid_594045 = query.getOrDefault("key")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "key", valid_594045
  var valid_594046 = query.getOrDefault("prettyPrint")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(false))
  if valid_594046 != nil:
    section.add "prettyPrint", valid_594046
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

proc call*(call_594048: Call_SiteVerificationWebResourcePatch_594036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the list of owners for your website or domain. This method supports patch semantics.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_SiteVerificationWebResourcePatch_594036; id: string;
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
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  var body_594052 = newJObject()
  add(query_594051, "fields", newJString(fields))
  add(query_594051, "quotaUser", newJString(quotaUser))
  add(query_594051, "alt", newJString(alt))
  add(query_594051, "oauth_token", newJString(oauthToken))
  add(query_594051, "userIp", newJString(userIp))
  add(path_594050, "id", newJString(id))
  add(query_594051, "key", newJString(key))
  if body != nil:
    body_594052 = body
  add(query_594051, "prettyPrint", newJBool(prettyPrint))
  result = call_594049.call(path_594050, query_594051, nil, nil, body_594052)

var siteVerificationWebResourcePatch* = Call_SiteVerificationWebResourcePatch_594036(
    name: "siteVerificationWebResourcePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourcePatch_594037,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourcePatch_594038,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceDelete_594021 = ref object of OpenApiRestCall_593408
proc url_SiteVerificationWebResourceDelete_594023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webResource/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SiteVerificationWebResourceDelete_594022(path: JsonNode;
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
  var valid_594024 = path.getOrDefault("id")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "id", valid_594024
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
  var valid_594025 = query.getOrDefault("fields")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "fields", valid_594025
  var valid_594026 = query.getOrDefault("quotaUser")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "quotaUser", valid_594026
  var valid_594027 = query.getOrDefault("alt")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("json"))
  if valid_594027 != nil:
    section.add "alt", valid_594027
  var valid_594028 = query.getOrDefault("oauth_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "oauth_token", valid_594028
  var valid_594029 = query.getOrDefault("userIp")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "userIp", valid_594029
  var valid_594030 = query.getOrDefault("key")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "key", valid_594030
  var valid_594031 = query.getOrDefault("prettyPrint")
  valid_594031 = validateParameter(valid_594031, JBool, required = false,
                                 default = newJBool(false))
  if valid_594031 != nil:
    section.add "prettyPrint", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_SiteVerificationWebResourceDelete_594021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Relinquish ownership of a website or domain.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_SiteVerificationWebResourceDelete_594021; id: string;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(query_594035, "fields", newJString(fields))
  add(query_594035, "quotaUser", newJString(quotaUser))
  add(query_594035, "alt", newJString(alt))
  add(query_594035, "oauth_token", newJString(oauthToken))
  add(query_594035, "userIp", newJString(userIp))
  add(path_594034, "id", newJString(id))
  add(query_594035, "key", newJString(key))
  add(query_594035, "prettyPrint", newJBool(prettyPrint))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var siteVerificationWebResourceDelete* = Call_SiteVerificationWebResourceDelete_594021(
    name: "siteVerificationWebResourceDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceDelete_594022,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceDelete_594023,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
