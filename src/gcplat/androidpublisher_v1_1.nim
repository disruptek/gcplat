
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Developer
## version: v1.1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses Android application developers' Google Play accounts.
## 
## https://developers.google.com/android-publisher
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherInapppurchasesGet_588710 = ref object of OpenApiRestCall_588441
proc url_AndroidpublisherInapppurchasesGet_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inapp/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/purchases/"),
               (kind: VariableSegment, value: "token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInapppurchasesGet_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the inapp product was purchased.
  ##   productId: JString (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_588838 = path.getOrDefault("packageName")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "packageName", valid_588838
  var valid_588839 = path.getOrDefault("token")
  valid_588839 = validateParameter(valid_588839, JString, required = true,
                                 default = nil)
  if valid_588839 != nil:
    section.add "token", valid_588839
  var valid_588840 = path.getOrDefault("productId")
  valid_588840 = validateParameter(valid_588840, JString, required = true,
                                 default = nil)
  if valid_588840 != nil:
    section.add "productId", valid_588840
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
  var valid_588841 = query.getOrDefault("fields")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "fields", valid_588841
  var valid_588842 = query.getOrDefault("quotaUser")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "quotaUser", valid_588842
  var valid_588856 = query.getOrDefault("alt")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("json"))
  if valid_588856 != nil:
    section.add "alt", valid_588856
  var valid_588857 = query.getOrDefault("oauth_token")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "oauth_token", valid_588857
  var valid_588858 = query.getOrDefault("userIp")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "userIp", valid_588858
  var valid_588859 = query.getOrDefault("key")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "key", valid_588859
  var valid_588860 = query.getOrDefault("prettyPrint")
  valid_588860 = validateParameter(valid_588860, JBool, required = false,
                                 default = newJBool(true))
  if valid_588860 != nil:
    section.add "prettyPrint", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_AndroidpublisherInapppurchasesGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_AndroidpublisherInapppurchasesGet_588710;
          packageName: string; token: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherInapppurchasesGet
  ## Checks the purchase and consumption status of an inapp item.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
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
  ##   token: string (required)
  ##        : The token provided to the user's device when the inapp product was purchased.
  ##   productId: string (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588955 = newJObject()
  var query_588957 = newJObject()
  add(query_588957, "fields", newJString(fields))
  add(path_588955, "packageName", newJString(packageName))
  add(query_588957, "quotaUser", newJString(quotaUser))
  add(query_588957, "alt", newJString(alt))
  add(query_588957, "oauth_token", newJString(oauthToken))
  add(query_588957, "userIp", newJString(userIp))
  add(query_588957, "key", newJString(key))
  add(path_588955, "token", newJString(token))
  add(path_588955, "productId", newJString(productId))
  add(query_588957, "prettyPrint", newJBool(prettyPrint))
  result = call_588954.call(path_588955, query_588957, nil, nil, nil)

var androidpublisherInapppurchasesGet* = Call_AndroidpublisherInapppurchasesGet_588710(
    name: "androidpublisherInapppurchasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/inapp/{productId}/purchases/{token}",
    validator: validate_AndroidpublisherInapppurchasesGet_588711,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherInapppurchasesGet_588712, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesGet_588996 = ref object of OpenApiRestCall_588441
proc url_AndroidpublisherPurchasesGet_588998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/purchases/"),
               (kind: VariableSegment, value: "token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesGet_588997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_588999 = path.getOrDefault("packageName")
  valid_588999 = validateParameter(valid_588999, JString, required = true,
                                 default = nil)
  if valid_588999 != nil:
    section.add "packageName", valid_588999
  var valid_589000 = path.getOrDefault("subscriptionId")
  valid_589000 = validateParameter(valid_589000, JString, required = true,
                                 default = nil)
  if valid_589000 != nil:
    section.add "subscriptionId", valid_589000
  var valid_589001 = path.getOrDefault("token")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "token", valid_589001
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
  var valid_589002 = query.getOrDefault("fields")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "fields", valid_589002
  var valid_589003 = query.getOrDefault("quotaUser")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "quotaUser", valid_589003
  var valid_589004 = query.getOrDefault("alt")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = newJString("json"))
  if valid_589004 != nil:
    section.add "alt", valid_589004
  var valid_589005 = query.getOrDefault("oauth_token")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "oauth_token", valid_589005
  var valid_589006 = query.getOrDefault("userIp")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "userIp", valid_589006
  var valid_589007 = query.getOrDefault("key")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "key", valid_589007
  var valid_589008 = query.getOrDefault("prettyPrint")
  valid_589008 = validateParameter(valid_589008, JBool, required = false,
                                 default = newJBool(true))
  if valid_589008 != nil:
    section.add "prettyPrint", valid_589008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589009: Call_AndroidpublisherPurchasesGet_588996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_589009.validator(path, query, header, formData, body)
  let scheme = call_589009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589009.url(scheme.get, call_589009.host, call_589009.base,
                         call_589009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589009, url, valid)

proc call*(call_589010: Call_AndroidpublisherPurchasesGet_588996;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesGet
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589011 = newJObject()
  var query_589012 = newJObject()
  add(query_589012, "fields", newJString(fields))
  add(path_589011, "packageName", newJString(packageName))
  add(query_589012, "quotaUser", newJString(quotaUser))
  add(query_589012, "alt", newJString(alt))
  add(path_589011, "subscriptionId", newJString(subscriptionId))
  add(query_589012, "oauth_token", newJString(oauthToken))
  add(query_589012, "userIp", newJString(userIp))
  add(query_589012, "key", newJString(key))
  add(path_589011, "token", newJString(token))
  add(query_589012, "prettyPrint", newJBool(prettyPrint))
  result = call_589010.call(path_589011, query_589012, nil, nil, nil)

var androidpublisherPurchasesGet* = Call_AndroidpublisherPurchasesGet_588996(
    name: "androidpublisherPurchasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}",
    validator: validate_AndroidpublisherPurchasesGet_588997,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherPurchasesGet_588998, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesCancel_589013 = ref object of OpenApiRestCall_588441
proc url_AndroidpublisherPurchasesCancel_589015(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/purchases/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesCancel_589014(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589016 = path.getOrDefault("packageName")
  valid_589016 = validateParameter(valid_589016, JString, required = true,
                                 default = nil)
  if valid_589016 != nil:
    section.add "packageName", valid_589016
  var valid_589017 = path.getOrDefault("subscriptionId")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "subscriptionId", valid_589017
  var valid_589018 = path.getOrDefault("token")
  valid_589018 = validateParameter(valid_589018, JString, required = true,
                                 default = nil)
  if valid_589018 != nil:
    section.add "token", valid_589018
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
  var valid_589019 = query.getOrDefault("fields")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "fields", valid_589019
  var valid_589020 = query.getOrDefault("quotaUser")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "quotaUser", valid_589020
  var valid_589021 = query.getOrDefault("alt")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = newJString("json"))
  if valid_589021 != nil:
    section.add "alt", valid_589021
  var valid_589022 = query.getOrDefault("oauth_token")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "oauth_token", valid_589022
  var valid_589023 = query.getOrDefault("userIp")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "userIp", valid_589023
  var valid_589024 = query.getOrDefault("key")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "key", valid_589024
  var valid_589025 = query.getOrDefault("prettyPrint")
  valid_589025 = validateParameter(valid_589025, JBool, required = false,
                                 default = newJBool(true))
  if valid_589025 != nil:
    section.add "prettyPrint", valid_589025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589026: Call_AndroidpublisherPurchasesCancel_589013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_AndroidpublisherPurchasesCancel_589013;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesCancel
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  add(query_589029, "fields", newJString(fields))
  add(path_589028, "packageName", newJString(packageName))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(path_589028, "subscriptionId", newJString(subscriptionId))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "userIp", newJString(userIp))
  add(query_589029, "key", newJString(key))
  add(path_589028, "token", newJString(token))
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589027.call(path_589028, query_589029, nil, nil, nil)

var androidpublisherPurchasesCancel* = Call_AndroidpublisherPurchasesCancel_589013(
    name: "androidpublisherPurchasesCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}/cancel",
    validator: validate_AndroidpublisherPurchasesCancel_589014,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherPurchasesCancel_589015, schemes: {Scheme.Https})
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
