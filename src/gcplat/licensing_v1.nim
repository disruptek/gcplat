
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Licensing
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Licensing API to view and manage licenses for your domain
## 
## https://developers.google.com/admin-sdk/licensing/
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

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "licensing"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LicensingLicenseAssignmentsInsert_579650 = ref object of OpenApiRestCall_579380
proc url_LicensingLicenseAssignmentsInsert_579652(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsInsert_579651(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign a license.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   productId: JString (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_579778 = path.getOrDefault("skuId")
  valid_579778 = validateParameter(valid_579778, JString, required = true,
                                 default = nil)
  if valid_579778 != nil:
    section.add "skuId", valid_579778
  var valid_579779 = path.getOrDefault("productId")
  valid_579779 = validateParameter(valid_579779, JString, required = true,
                                 default = nil)
  if valid_579779 != nil:
    section.add "productId", valid_579779
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579780 = query.getOrDefault("key")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "key", valid_579780
  var valid_579794 = query.getOrDefault("prettyPrint")
  valid_579794 = validateParameter(valid_579794, JBool, required = false,
                                 default = newJBool(true))
  if valid_579794 != nil:
    section.add "prettyPrint", valid_579794
  var valid_579795 = query.getOrDefault("oauth_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "oauth_token", valid_579795
  var valid_579796 = query.getOrDefault("alt")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = newJString("json"))
  if valid_579796 != nil:
    section.add "alt", valid_579796
  var valid_579797 = query.getOrDefault("userIp")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "userIp", valid_579797
  var valid_579798 = query.getOrDefault("quotaUser")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "quotaUser", valid_579798
  var valid_579799 = query.getOrDefault("fields")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "fields", valid_579799
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

proc call*(call_579823: Call_LicensingLicenseAssignmentsInsert_579650;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign a license.
  ## 
  let valid = call_579823.validator(path, query, header, formData, body)
  let scheme = call_579823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579823.url(scheme.get, call_579823.host, call_579823.base,
                         call_579823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579823, url, valid)

proc call*(call_579894: Call_LicensingLicenseAssignmentsInsert_579650;
          skuId: string; productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsInsert
  ## Assign a license.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  var path_579895 = newJObject()
  var query_579897 = newJObject()
  var body_579898 = newJObject()
  add(query_579897, "key", newJString(key))
  add(path_579895, "skuId", newJString(skuId))
  add(query_579897, "prettyPrint", newJBool(prettyPrint))
  add(query_579897, "oauth_token", newJString(oauthToken))
  add(query_579897, "alt", newJString(alt))
  add(query_579897, "userIp", newJString(userIp))
  add(query_579897, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579898 = body
  add(query_579897, "fields", newJString(fields))
  add(path_579895, "productId", newJString(productId))
  result = call_579894.call(path_579895, query_579897, nil, nil, body_579898)

var licensingLicenseAssignmentsInsert* = Call_LicensingLicenseAssignmentsInsert_579650(
    name: "licensingLicenseAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user",
    validator: validate_LicensingLicenseAssignmentsInsert_579651,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsInsert_579652, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsUpdate_579954 = ref object of OpenApiRestCall_579380
proc url_LicensingLicenseAssignmentsUpdate_579956(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsUpdate_579955(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reassign a user's product SKU with a different SKU in the same product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   userId: JString (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   productId: JString (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_579957 = path.getOrDefault("skuId")
  valid_579957 = validateParameter(valid_579957, JString, required = true,
                                 default = nil)
  if valid_579957 != nil:
    section.add "skuId", valid_579957
  var valid_579958 = path.getOrDefault("userId")
  valid_579958 = validateParameter(valid_579958, JString, required = true,
                                 default = nil)
  if valid_579958 != nil:
    section.add "userId", valid_579958
  var valid_579959 = path.getOrDefault("productId")
  valid_579959 = validateParameter(valid_579959, JString, required = true,
                                 default = nil)
  if valid_579959 != nil:
    section.add "productId", valid_579959
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579960 = query.getOrDefault("key")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "key", valid_579960
  var valid_579961 = query.getOrDefault("prettyPrint")
  valid_579961 = validateParameter(valid_579961, JBool, required = false,
                                 default = newJBool(true))
  if valid_579961 != nil:
    section.add "prettyPrint", valid_579961
  var valid_579962 = query.getOrDefault("oauth_token")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "oauth_token", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("userIp")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "userIp", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
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

proc call*(call_579968: Call_LicensingLicenseAssignmentsUpdate_579954;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reassign a user's product SKU with a different SKU in the same product.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_LicensingLicenseAssignmentsUpdate_579954;
          skuId: string; userId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsUpdate
  ## Reassign a user's product SKU with a different SKU in the same product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  var path_579970 = newJObject()
  var query_579971 = newJObject()
  var body_579972 = newJObject()
  add(query_579971, "key", newJString(key))
  add(path_579970, "skuId", newJString(skuId))
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "userIp", newJString(userIp))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(path_579970, "userId", newJString(userId))
  if body != nil:
    body_579972 = body
  add(query_579971, "fields", newJString(fields))
  add(path_579970, "productId", newJString(productId))
  result = call_579969.call(path_579970, query_579971, nil, nil, body_579972)

var licensingLicenseAssignmentsUpdate* = Call_LicensingLicenseAssignmentsUpdate_579954(
    name: "licensingLicenseAssignmentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsUpdate_579955,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsUpdate_579956, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsGet_579937 = ref object of OpenApiRestCall_579380
proc url_LicensingLicenseAssignmentsGet_579939(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsGet_579938(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific user's license by product SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   userId: JString (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   productId: JString (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_579940 = path.getOrDefault("skuId")
  valid_579940 = validateParameter(valid_579940, JString, required = true,
                                 default = nil)
  if valid_579940 != nil:
    section.add "skuId", valid_579940
  var valid_579941 = path.getOrDefault("userId")
  valid_579941 = validateParameter(valid_579941, JString, required = true,
                                 default = nil)
  if valid_579941 != nil:
    section.add "userId", valid_579941
  var valid_579942 = path.getOrDefault("productId")
  valid_579942 = validateParameter(valid_579942, JString, required = true,
                                 default = nil)
  if valid_579942 != nil:
    section.add "productId", valid_579942
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579943 = query.getOrDefault("key")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "key", valid_579943
  var valid_579944 = query.getOrDefault("prettyPrint")
  valid_579944 = validateParameter(valid_579944, JBool, required = false,
                                 default = newJBool(true))
  if valid_579944 != nil:
    section.add "prettyPrint", valid_579944
  var valid_579945 = query.getOrDefault("oauth_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "oauth_token", valid_579945
  var valid_579946 = query.getOrDefault("alt")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = newJString("json"))
  if valid_579946 != nil:
    section.add "alt", valid_579946
  var valid_579947 = query.getOrDefault("userIp")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "userIp", valid_579947
  var valid_579948 = query.getOrDefault("quotaUser")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "quotaUser", valid_579948
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579950: Call_LicensingLicenseAssignmentsGet_579937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific user's license by product SKU.
  ## 
  let valid = call_579950.validator(path, query, header, formData, body)
  let scheme = call_579950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579950.url(scheme.get, call_579950.host, call_579950.base,
                         call_579950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579950, url, valid)

proc call*(call_579951: Call_LicensingLicenseAssignmentsGet_579937; skuId: string;
          userId: string; productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsGet
  ## Get a specific user's license by product SKU.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  var path_579952 = newJObject()
  var query_579953 = newJObject()
  add(query_579953, "key", newJString(key))
  add(path_579952, "skuId", newJString(skuId))
  add(query_579953, "prettyPrint", newJBool(prettyPrint))
  add(query_579953, "oauth_token", newJString(oauthToken))
  add(query_579953, "alt", newJString(alt))
  add(query_579953, "userIp", newJString(userIp))
  add(query_579953, "quotaUser", newJString(quotaUser))
  add(path_579952, "userId", newJString(userId))
  add(query_579953, "fields", newJString(fields))
  add(path_579952, "productId", newJString(productId))
  result = call_579951.call(path_579952, query_579953, nil, nil, nil)

var licensingLicenseAssignmentsGet* = Call_LicensingLicenseAssignmentsGet_579937(
    name: "licensingLicenseAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsGet_579938,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsGet_579939,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsPatch_579990 = ref object of OpenApiRestCall_579380
proc url_LicensingLicenseAssignmentsPatch_579992(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsPatch_579991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reassign a user's product SKU with a different SKU in the same product. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   userId: JString (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   productId: JString (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_579993 = path.getOrDefault("skuId")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "skuId", valid_579993
  var valid_579994 = path.getOrDefault("userId")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "userId", valid_579994
  var valid_579995 = path.getOrDefault("productId")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "productId", valid_579995
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("userIp")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "userIp", valid_580000
  var valid_580001 = query.getOrDefault("quotaUser")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "quotaUser", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
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

proc call*(call_580004: Call_LicensingLicenseAssignmentsPatch_579990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reassign a user's product SKU with a different SKU in the same product. This method supports patch semantics.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_LicensingLicenseAssignmentsPatch_579990;
          skuId: string; userId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsPatch
  ## Reassign a user's product SKU with a different SKU in the same product. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  var body_580008 = newJObject()
  add(query_580007, "key", newJString(key))
  add(path_580006, "skuId", newJString(skuId))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(path_580006, "userId", newJString(userId))
  if body != nil:
    body_580008 = body
  add(query_580007, "fields", newJString(fields))
  add(path_580006, "productId", newJString(productId))
  result = call_580005.call(path_580006, query_580007, nil, nil, body_580008)

var licensingLicenseAssignmentsPatch* = Call_LicensingLicenseAssignmentsPatch_579990(
    name: "licensingLicenseAssignmentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsPatch_579991,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsPatch_579992,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsDelete_579973 = ref object of OpenApiRestCall_579380
proc url_LicensingLicenseAssignmentsDelete_579975(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsDelete_579974(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revoke a license.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   userId: JString (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   productId: JString (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_579976 = path.getOrDefault("skuId")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "skuId", valid_579976
  var valid_579977 = path.getOrDefault("userId")
  valid_579977 = validateParameter(valid_579977, JString, required = true,
                                 default = nil)
  if valid_579977 != nil:
    section.add "userId", valid_579977
  var valid_579978 = path.getOrDefault("productId")
  valid_579978 = validateParameter(valid_579978, JString, required = true,
                                 default = nil)
  if valid_579978 != nil:
    section.add "productId", valid_579978
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  var valid_579981 = query.getOrDefault("oauth_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "oauth_token", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("userIp")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "userIp", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579986: Call_LicensingLicenseAssignmentsDelete_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke a license.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_LicensingLicenseAssignmentsDelete_579973;
          skuId: string; userId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsDelete
  ## Revoke a license.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's current primary email address. If the user's email address changes, use the new email address in your API requests.
  ## Since a userId is subject to change, do not use a userId value as a key for persistent data. This key could break if the current user's email address changes.
  ## If the userId is suspended, the license status changes.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  add(query_579989, "key", newJString(key))
  add(path_579988, "skuId", newJString(skuId))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(path_579988, "userId", newJString(userId))
  add(query_579989, "fields", newJString(fields))
  add(path_579988, "productId", newJString(productId))
  result = call_579987.call(path_579988, query_579989, nil, nil, nil)

var licensingLicenseAssignmentsDelete* = Call_LicensingLicenseAssignmentsDelete_579973(
    name: "licensingLicenseAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsDelete_579974,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsDelete_579975, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProductAndSku_580009 = ref object of OpenApiRestCall_579380
proc url_LicensingLicenseAssignmentsListForProductAndSku_580011(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsListForProductAndSku_580010(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all users assigned licenses for a specific product SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   productId: JString (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_580012 = path.getOrDefault("skuId")
  valid_580012 = validateParameter(valid_580012, JString, required = true,
                                 default = nil)
  if valid_580012 != nil:
    section.add "skuId", valid_580012
  var valid_580013 = path.getOrDefault("productId")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "productId", valid_580013
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to fetch the next page of data. The maxResults query string is related to the pageToken since maxResults determines how many entries are returned on each page. This is an optional query string. If not specified, the server returns the first page.
  ##   customerId: JString (required)
  ##             : Customer's customerId. A previous version of this API accepted the primary domain name as a value for this field.
  ## If the customer is suspended, the server returns an error.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults query string determines how many entries are returned on each page of a large response. This is an optional parameter. The value must be a positive number.
  section = newJObject()
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("alt")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("json"))
  if valid_580017 != nil:
    section.add "alt", valid_580017
  var valid_580018 = query.getOrDefault("userIp")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "userIp", valid_580018
  var valid_580019 = query.getOrDefault("quotaUser")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "quotaUser", valid_580019
  var valid_580020 = query.getOrDefault("pageToken")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString(""))
  if valid_580020 != nil:
    section.add "pageToken", valid_580020
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_580021 = query.getOrDefault("customerId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "customerId", valid_580021
  var valid_580022 = query.getOrDefault("fields")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "fields", valid_580022
  var valid_580024 = query.getOrDefault("maxResults")
  valid_580024 = validateParameter(valid_580024, JInt, required = false,
                                 default = newJInt(100))
  if valid_580024 != nil:
    section.add "maxResults", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580025: Call_LicensingLicenseAssignmentsListForProductAndSku_580009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all users assigned licenses for a specific product SKU.
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_LicensingLicenseAssignmentsListForProductAndSku_580009;
          skuId: string; customerId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 100): Recallable =
  ## licensingLicenseAssignmentsListForProductAndSku
  ## List all users assigned licenses for a specific product SKU.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : A product SKU's unique identifier. For more information about available SKUs in this version of the API, see Products and SKUs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to fetch the next page of data. The maxResults query string is related to the pageToken since maxResults determines how many entries are returned on each page. This is an optional query string. If not specified, the server returns the first page.
  ##   customerId: string (required)
  ##             : Customer's customerId. A previous version of this API accepted the primary domain name as a value for this field.
  ## If the customer is suspended, the server returns an error.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  ##   maxResults: int
  ##             : The maxResults query string determines how many entries are returned on each page of a large response. This is an optional parameter. The value must be a positive number.
  var path_580027 = newJObject()
  var query_580028 = newJObject()
  add(query_580028, "key", newJString(key))
  add(path_580027, "skuId", newJString(skuId))
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "userIp", newJString(userIp))
  add(query_580028, "quotaUser", newJString(quotaUser))
  add(query_580028, "pageToken", newJString(pageToken))
  add(query_580028, "customerId", newJString(customerId))
  add(query_580028, "fields", newJString(fields))
  add(path_580027, "productId", newJString(productId))
  add(query_580028, "maxResults", newJInt(maxResults))
  result = call_580026.call(path_580027, query_580028, nil, nil, nil)

var licensingLicenseAssignmentsListForProductAndSku* = Call_LicensingLicenseAssignmentsListForProductAndSku_580009(
    name: "licensingLicenseAssignmentsListForProductAndSku",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{productId}/sku/{skuId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProductAndSku_580010,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProductAndSku_580011,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProduct_580029 = ref object of OpenApiRestCall_579380
proc url_LicensingLicenseAssignmentsListForProduct_580031(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_LicensingLicenseAssignmentsListForProduct_580030(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all users assigned licenses for a specific product SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_580032 = path.getOrDefault("productId")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "productId", valid_580032
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to fetch the next page of data. The maxResults query string is related to the pageToken since maxResults determines how many entries are returned on each page. This is an optional query string. If not specified, the server returns the first page.
  ##   customerId: JString (required)
  ##             : Customer's customerId. A previous version of this API accepted the primary domain name as a value for this field.
  ## If the customer is suspended, the server returns an error.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults query string determines how many entries are returned on each page of a large response. This is an optional parameter. The value must be a positive number.
  section = newJObject()
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("userIp")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userIp", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("pageToken")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString(""))
  if valid_580039 != nil:
    section.add "pageToken", valid_580039
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_580040 = query.getOrDefault("customerId")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "customerId", valid_580040
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
  var valid_580042 = query.getOrDefault("maxResults")
  valid_580042 = validateParameter(valid_580042, JInt, required = false,
                                 default = newJInt(100))
  if valid_580042 != nil:
    section.add "maxResults", valid_580042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580043: Call_LicensingLicenseAssignmentsListForProduct_580029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all users assigned licenses for a specific product SKU.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_LicensingLicenseAssignmentsListForProduct_580029;
          customerId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 100): Recallable =
  ## licensingLicenseAssignmentsListForProduct
  ## List all users assigned licenses for a specific product SKU.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to fetch the next page of data. The maxResults query string is related to the pageToken since maxResults determines how many entries are returned on each page. This is an optional query string. If not specified, the server returns the first page.
  ##   customerId: string (required)
  ##             : Customer's customerId. A previous version of this API accepted the primary domain name as a value for this field.
  ## If the customer is suspended, the server returns an error.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : A product's unique identifier. For more information about products in this version of the API, see Products and SKUs.
  ##   maxResults: int
  ##             : The maxResults query string determines how many entries are returned on each page of a large response. This is an optional parameter. The value must be a positive number.
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  add(query_580046, "key", newJString(key))
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "userIp", newJString(userIp))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(query_580046, "pageToken", newJString(pageToken))
  add(query_580046, "customerId", newJString(customerId))
  add(query_580046, "fields", newJString(fields))
  add(path_580045, "productId", newJString(productId))
  add(query_580046, "maxResults", newJInt(maxResults))
  result = call_580044.call(path_580045, query_580046, nil, nil, nil)

var licensingLicenseAssignmentsListForProduct* = Call_LicensingLicenseAssignmentsListForProduct_580029(
    name: "licensingLicenseAssignmentsListForProduct", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProduct_580030,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProduct_580031,
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
