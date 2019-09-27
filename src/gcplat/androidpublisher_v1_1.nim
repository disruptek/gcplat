
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherInapppurchasesGet_597677 = ref object of OpenApiRestCall_597408
proc url_AndroidpublisherInapppurchasesGet_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInapppurchasesGet_597678(path: JsonNode;
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
  var valid_597805 = path.getOrDefault("packageName")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "packageName", valid_597805
  var valid_597806 = path.getOrDefault("token")
  valid_597806 = validateParameter(valid_597806, JString, required = true,
                                 default = nil)
  if valid_597806 != nil:
    section.add "token", valid_597806
  var valid_597807 = path.getOrDefault("productId")
  valid_597807 = validateParameter(valid_597807, JString, required = true,
                                 default = nil)
  if valid_597807 != nil:
    section.add "productId", valid_597807
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
  var valid_597808 = query.getOrDefault("fields")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "fields", valid_597808
  var valid_597809 = query.getOrDefault("quotaUser")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "quotaUser", valid_597809
  var valid_597823 = query.getOrDefault("alt")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = newJString("json"))
  if valid_597823 != nil:
    section.add "alt", valid_597823
  var valid_597824 = query.getOrDefault("oauth_token")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "oauth_token", valid_597824
  var valid_597825 = query.getOrDefault("userIp")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "userIp", valid_597825
  var valid_597826 = query.getOrDefault("key")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "key", valid_597826
  var valid_597827 = query.getOrDefault("prettyPrint")
  valid_597827 = validateParameter(valid_597827, JBool, required = false,
                                 default = newJBool(true))
  if valid_597827 != nil:
    section.add "prettyPrint", valid_597827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597850: Call_AndroidpublisherInapppurchasesGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_597850.validator(path, query, header, formData, body)
  let scheme = call_597850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597850.url(scheme.get, call_597850.host, call_597850.base,
                         call_597850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597850, url, valid)

proc call*(call_597921: Call_AndroidpublisherInapppurchasesGet_597677;
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
  var path_597922 = newJObject()
  var query_597924 = newJObject()
  add(query_597924, "fields", newJString(fields))
  add(path_597922, "packageName", newJString(packageName))
  add(query_597924, "quotaUser", newJString(quotaUser))
  add(query_597924, "alt", newJString(alt))
  add(query_597924, "oauth_token", newJString(oauthToken))
  add(query_597924, "userIp", newJString(userIp))
  add(query_597924, "key", newJString(key))
  add(path_597922, "token", newJString(token))
  add(path_597922, "productId", newJString(productId))
  add(query_597924, "prettyPrint", newJBool(prettyPrint))
  result = call_597921.call(path_597922, query_597924, nil, nil, nil)

var androidpublisherInapppurchasesGet* = Call_AndroidpublisherInapppurchasesGet_597677(
    name: "androidpublisherInapppurchasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/inapp/{productId}/purchases/{token}",
    validator: validate_AndroidpublisherInapppurchasesGet_597678,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherInapppurchasesGet_597679, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesGet_597963 = ref object of OpenApiRestCall_597408
proc url_AndroidpublisherPurchasesGet_597965(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesGet_597964(path: JsonNode; query: JsonNode;
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
  var valid_597966 = path.getOrDefault("packageName")
  valid_597966 = validateParameter(valid_597966, JString, required = true,
                                 default = nil)
  if valid_597966 != nil:
    section.add "packageName", valid_597966
  var valid_597967 = path.getOrDefault("subscriptionId")
  valid_597967 = validateParameter(valid_597967, JString, required = true,
                                 default = nil)
  if valid_597967 != nil:
    section.add "subscriptionId", valid_597967
  var valid_597968 = path.getOrDefault("token")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "token", valid_597968
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
  var valid_597969 = query.getOrDefault("fields")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "fields", valid_597969
  var valid_597970 = query.getOrDefault("quotaUser")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "quotaUser", valid_597970
  var valid_597971 = query.getOrDefault("alt")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = newJString("json"))
  if valid_597971 != nil:
    section.add "alt", valid_597971
  var valid_597972 = query.getOrDefault("oauth_token")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "oauth_token", valid_597972
  var valid_597973 = query.getOrDefault("userIp")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "userIp", valid_597973
  var valid_597974 = query.getOrDefault("key")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "key", valid_597974
  var valid_597975 = query.getOrDefault("prettyPrint")
  valid_597975 = validateParameter(valid_597975, JBool, required = false,
                                 default = newJBool(true))
  if valid_597975 != nil:
    section.add "prettyPrint", valid_597975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597976: Call_AndroidpublisherPurchasesGet_597963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_597976.validator(path, query, header, formData, body)
  let scheme = call_597976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597976.url(scheme.get, call_597976.host, call_597976.base,
                         call_597976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597976, url, valid)

proc call*(call_597977: Call_AndroidpublisherPurchasesGet_597963;
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
  var path_597978 = newJObject()
  var query_597979 = newJObject()
  add(query_597979, "fields", newJString(fields))
  add(path_597978, "packageName", newJString(packageName))
  add(query_597979, "quotaUser", newJString(quotaUser))
  add(query_597979, "alt", newJString(alt))
  add(path_597978, "subscriptionId", newJString(subscriptionId))
  add(query_597979, "oauth_token", newJString(oauthToken))
  add(query_597979, "userIp", newJString(userIp))
  add(query_597979, "key", newJString(key))
  add(path_597978, "token", newJString(token))
  add(query_597979, "prettyPrint", newJBool(prettyPrint))
  result = call_597977.call(path_597978, query_597979, nil, nil, nil)

var androidpublisherPurchasesGet* = Call_AndroidpublisherPurchasesGet_597963(
    name: "androidpublisherPurchasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}",
    validator: validate_AndroidpublisherPurchasesGet_597964,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherPurchasesGet_597965, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesCancel_597980 = ref object of OpenApiRestCall_597408
proc url_AndroidpublisherPurchasesCancel_597982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesCancel_597981(path: JsonNode;
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
  var valid_597983 = path.getOrDefault("packageName")
  valid_597983 = validateParameter(valid_597983, JString, required = true,
                                 default = nil)
  if valid_597983 != nil:
    section.add "packageName", valid_597983
  var valid_597984 = path.getOrDefault("subscriptionId")
  valid_597984 = validateParameter(valid_597984, JString, required = true,
                                 default = nil)
  if valid_597984 != nil:
    section.add "subscriptionId", valid_597984
  var valid_597985 = path.getOrDefault("token")
  valid_597985 = validateParameter(valid_597985, JString, required = true,
                                 default = nil)
  if valid_597985 != nil:
    section.add "token", valid_597985
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
  var valid_597986 = query.getOrDefault("fields")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "fields", valid_597986
  var valid_597987 = query.getOrDefault("quotaUser")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "quotaUser", valid_597987
  var valid_597988 = query.getOrDefault("alt")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = newJString("json"))
  if valid_597988 != nil:
    section.add "alt", valid_597988
  var valid_597989 = query.getOrDefault("oauth_token")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "oauth_token", valid_597989
  var valid_597990 = query.getOrDefault("userIp")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "userIp", valid_597990
  var valid_597991 = query.getOrDefault("key")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "key", valid_597991
  var valid_597992 = query.getOrDefault("prettyPrint")
  valid_597992 = validateParameter(valid_597992, JBool, required = false,
                                 default = newJBool(true))
  if valid_597992 != nil:
    section.add "prettyPrint", valid_597992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597993: Call_AndroidpublisherPurchasesCancel_597980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_597993.validator(path, query, header, formData, body)
  let scheme = call_597993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597993.url(scheme.get, call_597993.host, call_597993.base,
                         call_597993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597993, url, valid)

proc call*(call_597994: Call_AndroidpublisherPurchasesCancel_597980;
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
  var path_597995 = newJObject()
  var query_597996 = newJObject()
  add(query_597996, "fields", newJString(fields))
  add(path_597995, "packageName", newJString(packageName))
  add(query_597996, "quotaUser", newJString(quotaUser))
  add(query_597996, "alt", newJString(alt))
  add(path_597995, "subscriptionId", newJString(subscriptionId))
  add(query_597996, "oauth_token", newJString(oauthToken))
  add(query_597996, "userIp", newJString(userIp))
  add(query_597996, "key", newJString(key))
  add(path_597995, "token", newJString(token))
  add(query_597996, "prettyPrint", newJBool(prettyPrint))
  result = call_597994.call(path_597995, query_597996, nil, nil, nil)

var androidpublisherPurchasesCancel* = Call_AndroidpublisherPurchasesCancel_597980(
    name: "androidpublisherPurchasesCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}/cancel",
    validator: validate_AndroidpublisherPurchasesCancel_597981,
    base: "/androidpublisher/v1.1/applications",
    url: url_AndroidpublisherPurchasesCancel_597982, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
