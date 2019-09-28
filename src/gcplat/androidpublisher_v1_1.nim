
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherInapppurchasesGet_579677 = ref object of OpenApiRestCall_579408
proc url_AndroidpublisherInapppurchasesGet_579679(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInapppurchasesGet_579678(path: JsonNode;
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
  var valid_579805 = path.getOrDefault("packageName")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "packageName", valid_579805
  var valid_579806 = path.getOrDefault("token")
  valid_579806 = validateParameter(valid_579806, JString, required = true,
                                 default = nil)
  if valid_579806 != nil:
    section.add "token", valid_579806
  var valid_579807 = path.getOrDefault("productId")
  valid_579807 = validateParameter(valid_579807, JString, required = true,
                                 default = nil)
  if valid_579807 != nil:
    section.add "productId", valid_579807
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
  var valid_579808 = query.getOrDefault("fields")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "fields", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("userIp")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "userIp", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579850: Call_AndroidpublisherInapppurchasesGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_579850.validator(path, query, header, formData, body)
  let scheme = call_579850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579850.url(scheme.get, call_579850.host, call_579850.base,
                         call_579850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579850, url, valid)

proc call*(call_579921: Call_AndroidpublisherInapppurchasesGet_579677;
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
  var path_579922 = newJObject()
  var query_579924 = newJObject()
  add(query_579924, "fields", newJString(fields))
  add(path_579922, "packageName", newJString(packageName))
  add(query_579924, "quotaUser", newJString(quotaUser))
  add(query_579924, "alt", newJString(alt))
  add(query_579924, "oauth_token", newJString(oauthToken))
  add(query_579924, "userIp", newJString(userIp))
  add(query_579924, "key", newJString(key))
  add(path_579922, "token", newJString(token))
  add(path_579922, "productId", newJString(productId))
  add(query_579924, "prettyPrint", newJBool(prettyPrint))
  result = call_579921.call(path_579922, query_579924, nil, nil, nil)

var androidpublisherInapppurchasesGet* = Call_AndroidpublisherInapppurchasesGet_579677(
    name: "androidpublisherInapppurchasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/inapp/{productId}/purchases/{token}",
    validator: validate_AndroidpublisherInapppurchasesGet_579678,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherInapppurchasesGet_579679, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesGet_579963 = ref object of OpenApiRestCall_579408
proc url_AndroidpublisherPurchasesGet_579965(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherPurchasesGet_579964(path: JsonNode; query: JsonNode;
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
  var valid_579966 = path.getOrDefault("packageName")
  valid_579966 = validateParameter(valid_579966, JString, required = true,
                                 default = nil)
  if valid_579966 != nil:
    section.add "packageName", valid_579966
  var valid_579967 = path.getOrDefault("subscriptionId")
  valid_579967 = validateParameter(valid_579967, JString, required = true,
                                 default = nil)
  if valid_579967 != nil:
    section.add "subscriptionId", valid_579967
  var valid_579968 = path.getOrDefault("token")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "token", valid_579968
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
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  var valid_579970 = query.getOrDefault("quotaUser")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "quotaUser", valid_579970
  var valid_579971 = query.getOrDefault("alt")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("json"))
  if valid_579971 != nil:
    section.add "alt", valid_579971
  var valid_579972 = query.getOrDefault("oauth_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "oauth_token", valid_579972
  var valid_579973 = query.getOrDefault("userIp")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "userIp", valid_579973
  var valid_579974 = query.getOrDefault("key")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "key", valid_579974
  var valid_579975 = query.getOrDefault("prettyPrint")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "prettyPrint", valid_579975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579976: Call_AndroidpublisherPurchasesGet_579963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_579976.validator(path, query, header, formData, body)
  let scheme = call_579976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579976.url(scheme.get, call_579976.host, call_579976.base,
                         call_579976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579976, url, valid)

proc call*(call_579977: Call_AndroidpublisherPurchasesGet_579963;
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
  var path_579978 = newJObject()
  var query_579979 = newJObject()
  add(query_579979, "fields", newJString(fields))
  add(path_579978, "packageName", newJString(packageName))
  add(query_579979, "quotaUser", newJString(quotaUser))
  add(query_579979, "alt", newJString(alt))
  add(path_579978, "subscriptionId", newJString(subscriptionId))
  add(query_579979, "oauth_token", newJString(oauthToken))
  add(query_579979, "userIp", newJString(userIp))
  add(query_579979, "key", newJString(key))
  add(path_579978, "token", newJString(token))
  add(query_579979, "prettyPrint", newJBool(prettyPrint))
  result = call_579977.call(path_579978, query_579979, nil, nil, nil)

var androidpublisherPurchasesGet* = Call_AndroidpublisherPurchasesGet_579963(
    name: "androidpublisherPurchasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}",
    validator: validate_AndroidpublisherPurchasesGet_579964,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherPurchasesGet_579965, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesCancel_579980 = ref object of OpenApiRestCall_579408
proc url_AndroidpublisherPurchasesCancel_579982(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherPurchasesCancel_579981(path: JsonNode;
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
  var valid_579983 = path.getOrDefault("packageName")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "packageName", valid_579983
  var valid_579984 = path.getOrDefault("subscriptionId")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "subscriptionId", valid_579984
  var valid_579985 = path.getOrDefault("token")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "token", valid_579985
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
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("userIp")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "userIp", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_AndroidpublisherPurchasesCancel_579980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_AndroidpublisherPurchasesCancel_579980;
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "fields", newJString(fields))
  add(path_579995, "packageName", newJString(packageName))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(path_579995, "subscriptionId", newJString(subscriptionId))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "userIp", newJString(userIp))
  add(query_579996, "key", newJString(key))
  add(path_579995, "token", newJString(token))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var androidpublisherPurchasesCancel* = Call_AndroidpublisherPurchasesCancel_579980(
    name: "androidpublisherPurchasesCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}/cancel",
    validator: validate_AndroidpublisherPurchasesCancel_579981,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherPurchasesCancel_579982, schemes: {Scheme.Https})
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
