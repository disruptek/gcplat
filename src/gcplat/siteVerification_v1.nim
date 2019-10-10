
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
  gcpServiceName = "siteVerification"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SiteVerificationWebResourceGetToken_588709 = ref object of OpenApiRestCall_588441
proc url_SiteVerificationWebResourceGetToken_588711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceGetToken_588710(path: JsonNode;
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
                                 default = newJBool(false))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
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

proc call*(call_588866: Call_SiteVerificationWebResourceGetToken_588709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a verification token for placing on a website or domain.
  ## 
  let valid = call_588866.validator(path, query, header, formData, body)
  let scheme = call_588866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588866.url(scheme.get, call_588866.host, call_588866.base,
                         call_588866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588866, url, valid)

proc call*(call_588937: Call_SiteVerificationWebResourceGetToken_588709;
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
  var query_588938 = newJObject()
  var body_588940 = newJObject()
  add(query_588938, "fields", newJString(fields))
  add(query_588938, "quotaUser", newJString(quotaUser))
  add(query_588938, "alt", newJString(alt))
  add(query_588938, "oauth_token", newJString(oauthToken))
  add(query_588938, "userIp", newJString(userIp))
  add(query_588938, "key", newJString(key))
  if body != nil:
    body_588940 = body
  add(query_588938, "prettyPrint", newJBool(prettyPrint))
  result = call_588937.call(nil, query_588938, nil, nil, body_588940)

var siteVerificationWebResourceGetToken* = Call_SiteVerificationWebResourceGetToken_588709(
    name: "siteVerificationWebResourceGetToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/token",
    validator: validate_SiteVerificationWebResourceGetToken_588710,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceGetToken_588711,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceInsert_588992 = ref object of OpenApiRestCall_588441
proc url_SiteVerificationWebResourceInsert_588994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceInsert_588993(path: JsonNode;
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
  var valid_588995 = query.getOrDefault("fields")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "fields", valid_588995
  var valid_588996 = query.getOrDefault("quotaUser")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "quotaUser", valid_588996
  var valid_588997 = query.getOrDefault("alt")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("json"))
  if valid_588997 != nil:
    section.add "alt", valid_588997
  var valid_588998 = query.getOrDefault("oauth_token")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "oauth_token", valid_588998
  var valid_588999 = query.getOrDefault("userIp")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "userIp", valid_588999
  var valid_589000 = query.getOrDefault("key")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "key", valid_589000
  assert query != nil, "query argument is necessary due to required `verificationMethod` field"
  var valid_589001 = query.getOrDefault("verificationMethod")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "verificationMethod", valid_589001
  var valid_589002 = query.getOrDefault("prettyPrint")
  valid_589002 = validateParameter(valid_589002, JBool, required = false,
                                 default = newJBool(false))
  if valid_589002 != nil:
    section.add "prettyPrint", valid_589002
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

proc call*(call_589004: Call_SiteVerificationWebResourceInsert_588992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attempt verification of a website or domain.
  ## 
  let valid = call_589004.validator(path, query, header, formData, body)
  let scheme = call_589004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589004.url(scheme.get, call_589004.host, call_589004.base,
                         call_589004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589004, url, valid)

proc call*(call_589005: Call_SiteVerificationWebResourceInsert_588992;
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
  var query_589006 = newJObject()
  var body_589007 = newJObject()
  add(query_589006, "fields", newJString(fields))
  add(query_589006, "quotaUser", newJString(quotaUser))
  add(query_589006, "alt", newJString(alt))
  add(query_589006, "oauth_token", newJString(oauthToken))
  add(query_589006, "userIp", newJString(userIp))
  add(query_589006, "key", newJString(key))
  add(query_589006, "verificationMethod", newJString(verificationMethod))
  if body != nil:
    body_589007 = body
  add(query_589006, "prettyPrint", newJBool(prettyPrint))
  result = call_589005.call(nil, query_589006, nil, nil, body_589007)

var siteVerificationWebResourceInsert* = Call_SiteVerificationWebResourceInsert_588992(
    name: "siteVerificationWebResourceInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/webResource",
    validator: validate_SiteVerificationWebResourceInsert_588993,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceInsert_588994,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceList_588979 = ref object of OpenApiRestCall_588441
proc url_SiteVerificationWebResourceList_588981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SiteVerificationWebResourceList_588980(path: JsonNode;
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
  var valid_588982 = query.getOrDefault("fields")
  valid_588982 = validateParameter(valid_588982, JString, required = false,
                                 default = nil)
  if valid_588982 != nil:
    section.add "fields", valid_588982
  var valid_588983 = query.getOrDefault("quotaUser")
  valid_588983 = validateParameter(valid_588983, JString, required = false,
                                 default = nil)
  if valid_588983 != nil:
    section.add "quotaUser", valid_588983
  var valid_588984 = query.getOrDefault("alt")
  valid_588984 = validateParameter(valid_588984, JString, required = false,
                                 default = newJString("json"))
  if valid_588984 != nil:
    section.add "alt", valid_588984
  var valid_588985 = query.getOrDefault("oauth_token")
  valid_588985 = validateParameter(valid_588985, JString, required = false,
                                 default = nil)
  if valid_588985 != nil:
    section.add "oauth_token", valid_588985
  var valid_588986 = query.getOrDefault("userIp")
  valid_588986 = validateParameter(valid_588986, JString, required = false,
                                 default = nil)
  if valid_588986 != nil:
    section.add "userIp", valid_588986
  var valid_588987 = query.getOrDefault("key")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "key", valid_588987
  var valid_588988 = query.getOrDefault("prettyPrint")
  valid_588988 = validateParameter(valid_588988, JBool, required = false,
                                 default = newJBool(false))
  if valid_588988 != nil:
    section.add "prettyPrint", valid_588988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588989: Call_SiteVerificationWebResourceList_588979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of your verified websites and domains.
  ## 
  let valid = call_588989.validator(path, query, header, formData, body)
  let scheme = call_588989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588989.url(scheme.get, call_588989.host, call_588989.base,
                         call_588989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588989, url, valid)

proc call*(call_588990: Call_SiteVerificationWebResourceList_588979;
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
  var query_588991 = newJObject()
  add(query_588991, "fields", newJString(fields))
  add(query_588991, "quotaUser", newJString(quotaUser))
  add(query_588991, "alt", newJString(alt))
  add(query_588991, "oauth_token", newJString(oauthToken))
  add(query_588991, "userIp", newJString(userIp))
  add(query_588991, "key", newJString(key))
  add(query_588991, "prettyPrint", newJBool(prettyPrint))
  result = call_588990.call(nil, query_588991, nil, nil, nil)

var siteVerificationWebResourceList* = Call_SiteVerificationWebResourceList_588979(
    name: "siteVerificationWebResourceList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/webResource",
    validator: validate_SiteVerificationWebResourceList_588980,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceList_588981,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceUpdate_589037 = ref object of OpenApiRestCall_588441
proc url_SiteVerificationWebResourceUpdate_589039(protocol: Scheme; host: string;
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

proc validate_SiteVerificationWebResourceUpdate_589038(path: JsonNode;
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
  var valid_589040 = path.getOrDefault("id")
  valid_589040 = validateParameter(valid_589040, JString, required = true,
                                 default = nil)
  if valid_589040 != nil:
    section.add "id", valid_589040
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
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("userIp")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "userIp", valid_589045
  var valid_589046 = query.getOrDefault("key")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "key", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(false))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
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

proc call*(call_589049: Call_SiteVerificationWebResourceUpdate_589037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the list of owners for your website or domain.
  ## 
  let valid = call_589049.validator(path, query, header, formData, body)
  let scheme = call_589049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589049.url(scheme.get, call_589049.host, call_589049.base,
                         call_589049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589049, url, valid)

proc call*(call_589050: Call_SiteVerificationWebResourceUpdate_589037; id: string;
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
  var path_589051 = newJObject()
  var query_589052 = newJObject()
  var body_589053 = newJObject()
  add(query_589052, "fields", newJString(fields))
  add(query_589052, "quotaUser", newJString(quotaUser))
  add(query_589052, "alt", newJString(alt))
  add(query_589052, "oauth_token", newJString(oauthToken))
  add(query_589052, "userIp", newJString(userIp))
  add(path_589051, "id", newJString(id))
  add(query_589052, "key", newJString(key))
  if body != nil:
    body_589053 = body
  add(query_589052, "prettyPrint", newJBool(prettyPrint))
  result = call_589050.call(path_589051, query_589052, nil, nil, body_589053)

var siteVerificationWebResourceUpdate* = Call_SiteVerificationWebResourceUpdate_589037(
    name: "siteVerificationWebResourceUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceUpdate_589038,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceUpdate_589039,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceGet_589008 = ref object of OpenApiRestCall_588441
proc url_SiteVerificationWebResourceGet_589010(protocol: Scheme; host: string;
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

proc validate_SiteVerificationWebResourceGet_589009(path: JsonNode;
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
  var valid_589025 = path.getOrDefault("id")
  valid_589025 = validateParameter(valid_589025, JString, required = true,
                                 default = nil)
  if valid_589025 != nil:
    section.add "id", valid_589025
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
  var valid_589026 = query.getOrDefault("fields")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "fields", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("userIp")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "userIp", valid_589030
  var valid_589031 = query.getOrDefault("key")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "key", valid_589031
  var valid_589032 = query.getOrDefault("prettyPrint")
  valid_589032 = validateParameter(valid_589032, JBool, required = false,
                                 default = newJBool(false))
  if valid_589032 != nil:
    section.add "prettyPrint", valid_589032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589033: Call_SiteVerificationWebResourceGet_589008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the most current data for a website or domain.
  ## 
  let valid = call_589033.validator(path, query, header, formData, body)
  let scheme = call_589033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589033.url(scheme.get, call_589033.host, call_589033.base,
                         call_589033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589033, url, valid)

proc call*(call_589034: Call_SiteVerificationWebResourceGet_589008; id: string;
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
  var path_589035 = newJObject()
  var query_589036 = newJObject()
  add(query_589036, "fields", newJString(fields))
  add(query_589036, "quotaUser", newJString(quotaUser))
  add(query_589036, "alt", newJString(alt))
  add(query_589036, "oauth_token", newJString(oauthToken))
  add(query_589036, "userIp", newJString(userIp))
  add(path_589035, "id", newJString(id))
  add(query_589036, "key", newJString(key))
  add(query_589036, "prettyPrint", newJBool(prettyPrint))
  result = call_589034.call(path_589035, query_589036, nil, nil, nil)

var siteVerificationWebResourceGet* = Call_SiteVerificationWebResourceGet_589008(
    name: "siteVerificationWebResourceGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceGet_589009,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceGet_589010,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourcePatch_589069 = ref object of OpenApiRestCall_588441
proc url_SiteVerificationWebResourcePatch_589071(protocol: Scheme; host: string;
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

proc validate_SiteVerificationWebResourcePatch_589070(path: JsonNode;
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
  var valid_589072 = path.getOrDefault("id")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "id", valid_589072
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
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("userIp")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "userIp", valid_589077
  var valid_589078 = query.getOrDefault("key")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "key", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(false))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
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

proc call*(call_589081: Call_SiteVerificationWebResourcePatch_589069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the list of owners for your website or domain. This method supports patch semantics.
  ## 
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_SiteVerificationWebResourcePatch_589069; id: string;
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
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  var body_589085 = newJObject()
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(query_589084, "alt", newJString(alt))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "userIp", newJString(userIp))
  add(path_589083, "id", newJString(id))
  add(query_589084, "key", newJString(key))
  if body != nil:
    body_589085 = body
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  result = call_589082.call(path_589083, query_589084, nil, nil, body_589085)

var siteVerificationWebResourcePatch* = Call_SiteVerificationWebResourcePatch_589069(
    name: "siteVerificationWebResourcePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourcePatch_589070,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourcePatch_589071,
    schemes: {Scheme.Https})
type
  Call_SiteVerificationWebResourceDelete_589054 = ref object of OpenApiRestCall_588441
proc url_SiteVerificationWebResourceDelete_589056(protocol: Scheme; host: string;
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

proc validate_SiteVerificationWebResourceDelete_589055(path: JsonNode;
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
  var valid_589057 = path.getOrDefault("id")
  valid_589057 = validateParameter(valid_589057, JString, required = true,
                                 default = nil)
  if valid_589057 != nil:
    section.add "id", valid_589057
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
  var valid_589058 = query.getOrDefault("fields")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "fields", valid_589058
  var valid_589059 = query.getOrDefault("quotaUser")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "quotaUser", valid_589059
  var valid_589060 = query.getOrDefault("alt")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("json"))
  if valid_589060 != nil:
    section.add "alt", valid_589060
  var valid_589061 = query.getOrDefault("oauth_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "oauth_token", valid_589061
  var valid_589062 = query.getOrDefault("userIp")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "userIp", valid_589062
  var valid_589063 = query.getOrDefault("key")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "key", valid_589063
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(false))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589065: Call_SiteVerificationWebResourceDelete_589054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Relinquish ownership of a website or domain.
  ## 
  let valid = call_589065.validator(path, query, header, formData, body)
  let scheme = call_589065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589065.url(scheme.get, call_589065.host, call_589065.base,
                         call_589065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589065, url, valid)

proc call*(call_589066: Call_SiteVerificationWebResourceDelete_589054; id: string;
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
  var path_589067 = newJObject()
  var query_589068 = newJObject()
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(query_589068, "alt", newJString(alt))
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "userIp", newJString(userIp))
  add(path_589067, "id", newJString(id))
  add(query_589068, "key", newJString(key))
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  result = call_589066.call(path_589067, query_589068, nil, nil, nil)

var siteVerificationWebResourceDelete* = Call_SiteVerificationWebResourceDelete_589054(
    name: "siteVerificationWebResourceDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/webResource/{id}",
    validator: validate_SiteVerificationWebResourceDelete_589055,
    base: "/siteVerification/v1", url: url_SiteVerificationWebResourceDelete_589056,
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
