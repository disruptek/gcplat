
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Enterprise License Manager
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Views and manages licenses for your domain.
## 
## https://developers.google.com/google-apps/licensing/
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  gcpServiceName = "licensing"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LicensingLicenseAssignmentsInsert_588725 = ref object of OpenApiRestCall_588457
proc url_LicensingLicenseAssignmentsInsert_588727(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "skuId" in path, "`skuId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/sku/"),
               (kind: VariableSegment, value: "skuId"),
               (kind: ConstantSegment, value: "/user")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsInsert_588726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign License.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku
  ##   productId: JString (required)
  ##            : Name for product
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_588853 = path.getOrDefault("skuId")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "skuId", valid_588853
  var valid_588854 = path.getOrDefault("productId")
  valid_588854 = validateParameter(valid_588854, JString, required = true,
                                 default = nil)
  if valid_588854 != nil:
    section.add "productId", valid_588854
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
  var valid_588855 = query.getOrDefault("fields")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "fields", valid_588855
  var valid_588856 = query.getOrDefault("quotaUser")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "quotaUser", valid_588856
  var valid_588870 = query.getOrDefault("alt")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("json"))
  if valid_588870 != nil:
    section.add "alt", valid_588870
  var valid_588871 = query.getOrDefault("oauth_token")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "oauth_token", valid_588871
  var valid_588872 = query.getOrDefault("userIp")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "userIp", valid_588872
  var valid_588873 = query.getOrDefault("key")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "key", valid_588873
  var valid_588874 = query.getOrDefault("prettyPrint")
  valid_588874 = validateParameter(valid_588874, JBool, required = false,
                                 default = newJBool(true))
  if valid_588874 != nil:
    section.add "prettyPrint", valid_588874
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

proc call*(call_588898: Call_LicensingLicenseAssignmentsInsert_588725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_588898.validator(path, query, header, formData, body)
  let scheme = call_588898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588898.url(scheme.get, call_588898.host, call_588898.base,
                         call_588898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588898, url, valid)

proc call*(call_588969: Call_LicensingLicenseAssignmentsInsert_588725;
          skuId: string; productId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## licensingLicenseAssignmentsInsert
  ## Assign License.
  ##   skuId: string (required)
  ##        : Name for sku
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
  ##   productId: string (required)
  ##            : Name for product
  var path_588970 = newJObject()
  var query_588972 = newJObject()
  var body_588973 = newJObject()
  add(path_588970, "skuId", newJString(skuId))
  add(query_588972, "fields", newJString(fields))
  add(query_588972, "quotaUser", newJString(quotaUser))
  add(query_588972, "alt", newJString(alt))
  add(query_588972, "oauth_token", newJString(oauthToken))
  add(query_588972, "userIp", newJString(userIp))
  add(query_588972, "key", newJString(key))
  if body != nil:
    body_588973 = body
  add(query_588972, "prettyPrint", newJBool(prettyPrint))
  add(path_588970, "productId", newJString(productId))
  result = call_588969.call(path_588970, query_588972, nil, nil, body_588973)

var licensingLicenseAssignmentsInsert* = Call_LicensingLicenseAssignmentsInsert_588725(
    name: "licensingLicenseAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user",
    validator: validate_LicensingLicenseAssignmentsInsert_588726,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsInsert_588727, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsUpdate_589029 = ref object of OpenApiRestCall_588457
proc url_LicensingLicenseAssignmentsUpdate_589031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "skuId" in path, "`skuId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/sku/"),
               (kind: VariableSegment, value: "skuId"),
               (kind: ConstantSegment, value: "/user/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsUpdate_589030(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign License.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku for which license would be revoked
  ##   productId: JString (required)
  ##            : Name for product
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_589032 = path.getOrDefault("skuId")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "skuId", valid_589032
  var valid_589033 = path.getOrDefault("productId")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "productId", valid_589033
  var valid_589034 = path.getOrDefault("userId")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "userId", valid_589034
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
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("userIp")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "userIp", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
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

proc call*(call_589043: Call_LicensingLicenseAssignmentsUpdate_589029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_LicensingLicenseAssignmentsUpdate_589029;
          skuId: string; productId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## licensingLicenseAssignmentsUpdate
  ## Assign License.
  ##   skuId: string (required)
  ##        : Name for sku for which license would be revoked
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
  ##   productId: string (required)
  ##            : Name for product
  ##   userId: string (required)
  ##         : email id or unique Id of the user
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  var body_589047 = newJObject()
  add(path_589045, "skuId", newJString(skuId))
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "userIp", newJString(userIp))
  add(query_589046, "key", newJString(key))
  if body != nil:
    body_589047 = body
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  add(path_589045, "productId", newJString(productId))
  add(path_589045, "userId", newJString(userId))
  result = call_589044.call(path_589045, query_589046, nil, nil, body_589047)

var licensingLicenseAssignmentsUpdate* = Call_LicensingLicenseAssignmentsUpdate_589029(
    name: "licensingLicenseAssignmentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsUpdate_589030,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsUpdate_589031, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsGet_589012 = ref object of OpenApiRestCall_588457
proc url_LicensingLicenseAssignmentsGet_589014(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "skuId" in path, "`skuId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/sku/"),
               (kind: VariableSegment, value: "skuId"),
               (kind: ConstantSegment, value: "/user/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsGet_589013(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get license assignment of a particular product and sku for a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku
  ##   productId: JString (required)
  ##            : Name for product
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_589015 = path.getOrDefault("skuId")
  valid_589015 = validateParameter(valid_589015, JString, required = true,
                                 default = nil)
  if valid_589015 != nil:
    section.add "skuId", valid_589015
  var valid_589016 = path.getOrDefault("productId")
  valid_589016 = validateParameter(valid_589016, JString, required = true,
                                 default = nil)
  if valid_589016 != nil:
    section.add "productId", valid_589016
  var valid_589017 = path.getOrDefault("userId")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "userId", valid_589017
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
  var valid_589018 = query.getOrDefault("fields")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "fields", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("userIp")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "userIp", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589025: Call_LicensingLicenseAssignmentsGet_589012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get license assignment of a particular product and sku for a user
  ## 
  let valid = call_589025.validator(path, query, header, formData, body)
  let scheme = call_589025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589025.url(scheme.get, call_589025.host, call_589025.base,
                         call_589025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589025, url, valid)

proc call*(call_589026: Call_LicensingLicenseAssignmentsGet_589012; skuId: string;
          productId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## licensingLicenseAssignmentsGet
  ## Get license assignment of a particular product and sku for a user
  ##   skuId: string (required)
  ##        : Name for sku
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
  ##   productId: string (required)
  ##            : Name for product
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : email id or unique Id of the user
  var path_589027 = newJObject()
  var query_589028 = newJObject()
  add(path_589027, "skuId", newJString(skuId))
  add(query_589028, "fields", newJString(fields))
  add(query_589028, "quotaUser", newJString(quotaUser))
  add(query_589028, "alt", newJString(alt))
  add(query_589028, "oauth_token", newJString(oauthToken))
  add(query_589028, "userIp", newJString(userIp))
  add(query_589028, "key", newJString(key))
  add(path_589027, "productId", newJString(productId))
  add(query_589028, "prettyPrint", newJBool(prettyPrint))
  add(path_589027, "userId", newJString(userId))
  result = call_589026.call(path_589027, query_589028, nil, nil, nil)

var licensingLicenseAssignmentsGet* = Call_LicensingLicenseAssignmentsGet_589012(
    name: "licensingLicenseAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsGet_589013,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsGet_589014,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsPatch_589065 = ref object of OpenApiRestCall_588457
proc url_LicensingLicenseAssignmentsPatch_589067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "skuId" in path, "`skuId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/sku/"),
               (kind: VariableSegment, value: "skuId"),
               (kind: ConstantSegment, value: "/user/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsPatch_589066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign License. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku for which license would be revoked
  ##   productId: JString (required)
  ##            : Name for product
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_589068 = path.getOrDefault("skuId")
  valid_589068 = validateParameter(valid_589068, JString, required = true,
                                 default = nil)
  if valid_589068 != nil:
    section.add "skuId", valid_589068
  var valid_589069 = path.getOrDefault("productId")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = nil)
  if valid_589069 != nil:
    section.add "productId", valid_589069
  var valid_589070 = path.getOrDefault("userId")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "userId", valid_589070
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
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("quotaUser")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "quotaUser", valid_589072
  var valid_589073 = query.getOrDefault("alt")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("json"))
  if valid_589073 != nil:
    section.add "alt", valid_589073
  var valid_589074 = query.getOrDefault("oauth_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "oauth_token", valid_589074
  var valid_589075 = query.getOrDefault("userIp")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "userIp", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
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

proc call*(call_589079: Call_LicensingLicenseAssignmentsPatch_589065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License. This method supports patch semantics.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_LicensingLicenseAssignmentsPatch_589065;
          skuId: string; productId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## licensingLicenseAssignmentsPatch
  ## Assign License. This method supports patch semantics.
  ##   skuId: string (required)
  ##        : Name for sku for which license would be revoked
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
  ##   productId: string (required)
  ##            : Name for product
  ##   userId: string (required)
  ##         : email id or unique Id of the user
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(path_589081, "skuId", newJString(skuId))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "userIp", newJString(userIp))
  add(query_589082, "key", newJString(key))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  add(path_589081, "productId", newJString(productId))
  add(path_589081, "userId", newJString(userId))
  result = call_589080.call(path_589081, query_589082, nil, nil, body_589083)

var licensingLicenseAssignmentsPatch* = Call_LicensingLicenseAssignmentsPatch_589065(
    name: "licensingLicenseAssignmentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsPatch_589066,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsPatch_589067,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsDelete_589048 = ref object of OpenApiRestCall_588457
proc url_LicensingLicenseAssignmentsDelete_589050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "skuId" in path, "`skuId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/sku/"),
               (kind: VariableSegment, value: "skuId"),
               (kind: ConstantSegment, value: "/user/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsDelete_589049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revoke License.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku
  ##   productId: JString (required)
  ##            : Name for product
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_589051 = path.getOrDefault("skuId")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "skuId", valid_589051
  var valid_589052 = path.getOrDefault("productId")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "productId", valid_589052
  var valid_589053 = path.getOrDefault("userId")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "userId", valid_589053
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
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("userIp")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "userIp", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  var valid_589060 = query.getOrDefault("prettyPrint")
  valid_589060 = validateParameter(valid_589060, JBool, required = false,
                                 default = newJBool(true))
  if valid_589060 != nil:
    section.add "prettyPrint", valid_589060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589061: Call_LicensingLicenseAssignmentsDelete_589048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke License.
  ## 
  let valid = call_589061.validator(path, query, header, formData, body)
  let scheme = call_589061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589061.url(scheme.get, call_589061.host, call_589061.base,
                         call_589061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589061, url, valid)

proc call*(call_589062: Call_LicensingLicenseAssignmentsDelete_589048;
          skuId: string; productId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## licensingLicenseAssignmentsDelete
  ## Revoke License.
  ##   skuId: string (required)
  ##        : Name for sku
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
  ##   productId: string (required)
  ##            : Name for product
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : email id or unique Id of the user
  var path_589063 = newJObject()
  var query_589064 = newJObject()
  add(path_589063, "skuId", newJString(skuId))
  add(query_589064, "fields", newJString(fields))
  add(query_589064, "quotaUser", newJString(quotaUser))
  add(query_589064, "alt", newJString(alt))
  add(query_589064, "oauth_token", newJString(oauthToken))
  add(query_589064, "userIp", newJString(userIp))
  add(query_589064, "key", newJString(key))
  add(path_589063, "productId", newJString(productId))
  add(query_589064, "prettyPrint", newJBool(prettyPrint))
  add(path_589063, "userId", newJString(userId))
  result = call_589062.call(path_589063, query_589064, nil, nil, nil)

var licensingLicenseAssignmentsDelete* = Call_LicensingLicenseAssignmentsDelete_589048(
    name: "licensingLicenseAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsDelete_589049,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsDelete_589050, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProductAndSku_589084 = ref object of OpenApiRestCall_588457
proc url_LicensingLicenseAssignmentsListForProductAndSku_589086(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "skuId" in path, "`skuId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/sku/"),
               (kind: VariableSegment, value: "skuId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsListForProductAndSku_589085(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List license assignments for given product and sku of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku
  ##   productId: JString (required)
  ##            : Name for product
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_589087 = path.getOrDefault("skuId")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "skuId", valid_589087
  var valid_589088 = path.getOrDefault("productId")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "productId", valid_589088
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589089 = query.getOrDefault("fields")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "fields", valid_589089
  var valid_589090 = query.getOrDefault("pageToken")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString(""))
  if valid_589090 != nil:
    section.add "pageToken", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_589093 = query.getOrDefault("customerId")
  valid_589093 = validateParameter(valid_589093, JString, required = true,
                                 default = nil)
  if valid_589093 != nil:
    section.add "customerId", valid_589093
  var valid_589094 = query.getOrDefault("oauth_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "oauth_token", valid_589094
  var valid_589095 = query.getOrDefault("userIp")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "userIp", valid_589095
  var valid_589097 = query.getOrDefault("maxResults")
  valid_589097 = validateParameter(valid_589097, JInt, required = false,
                                 default = newJInt(100))
  if valid_589097 != nil:
    section.add "maxResults", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_LicensingLicenseAssignmentsListForProductAndSku_589084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product and sku of the customer.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_LicensingLicenseAssignmentsListForProductAndSku_589084;
          skuId: string; customerId: string; productId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 100;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## licensingLicenseAssignmentsListForProductAndSku
  ## List license assignments for given product and sku of the customer.
  ##   skuId: string (required)
  ##        : Name for sku
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   productId: string (required)
  ##            : Name for product
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  add(path_589102, "skuId", newJString(skuId))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "pageToken", newJString(pageToken))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "customerId", newJString(customerId))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "userIp", newJString(userIp))
  add(query_589103, "maxResults", newJInt(maxResults))
  add(query_589103, "key", newJString(key))
  add(path_589102, "productId", newJString(productId))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, nil)

var licensingLicenseAssignmentsListForProductAndSku* = Call_LicensingLicenseAssignmentsListForProductAndSku_589084(
    name: "licensingLicenseAssignmentsListForProductAndSku",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{productId}/sku/{skuId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProductAndSku_589085,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProductAndSku_589086,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProduct_589104 = ref object of OpenApiRestCall_588457
proc url_LicensingLicenseAssignmentsListForProduct_589106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsListForProduct_589105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List license assignments for given product of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Name for product
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_589107 = path.getOrDefault("productId")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "productId", valid_589107
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589108 = query.getOrDefault("fields")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "fields", valid_589108
  var valid_589109 = query.getOrDefault("pageToken")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString(""))
  if valid_589109 != nil:
    section.add "pageToken", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_589112 = query.getOrDefault("customerId")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "customerId", valid_589112
  var valid_589113 = query.getOrDefault("oauth_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "oauth_token", valid_589113
  var valid_589114 = query.getOrDefault("userIp")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "userIp", valid_589114
  var valid_589115 = query.getOrDefault("maxResults")
  valid_589115 = validateParameter(valid_589115, JInt, required = false,
                                 default = newJInt(100))
  if valid_589115 != nil:
    section.add "maxResults", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589118: Call_LicensingLicenseAssignmentsListForProduct_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product of the customer.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_LicensingLicenseAssignmentsListForProduct_589104;
          customerId: string; productId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 100;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## licensingLicenseAssignmentsListForProduct
  ## List license assignments for given product of the customer.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   productId: string (required)
  ##            : Name for product
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "pageToken", newJString(pageToken))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "customerId", newJString(customerId))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "maxResults", newJInt(maxResults))
  add(query_589121, "key", newJString(key))
  add(path_589120, "productId", newJString(productId))
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  result = call_589119.call(path_589120, query_589121, nil, nil, nil)

var licensingLicenseAssignmentsListForProduct* = Call_LicensingLicenseAssignmentsListForProduct_589104(
    name: "licensingLicenseAssignmentsListForProduct", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProduct_589105,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProduct_589106,
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
