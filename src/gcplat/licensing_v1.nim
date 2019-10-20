
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  Call_LicensingLicenseAssignmentsInsert_578625 = ref object of OpenApiRestCall_578355
proc url_LicensingLicenseAssignmentsInsert_578627(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsInsert_578626(path: JsonNode;
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
  var valid_578753 = path.getOrDefault("skuId")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "skuId", valid_578753
  var valid_578754 = path.getOrDefault("productId")
  valid_578754 = validateParameter(valid_578754, JString, required = true,
                                 default = nil)
  if valid_578754 != nil:
    section.add "productId", valid_578754
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
  var valid_578755 = query.getOrDefault("key")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "key", valid_578755
  var valid_578769 = query.getOrDefault("prettyPrint")
  valid_578769 = validateParameter(valid_578769, JBool, required = false,
                                 default = newJBool(true))
  if valid_578769 != nil:
    section.add "prettyPrint", valid_578769
  var valid_578770 = query.getOrDefault("oauth_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "oauth_token", valid_578770
  var valid_578771 = query.getOrDefault("alt")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = newJString("json"))
  if valid_578771 != nil:
    section.add "alt", valid_578771
  var valid_578772 = query.getOrDefault("userIp")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "userIp", valid_578772
  var valid_578773 = query.getOrDefault("quotaUser")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "quotaUser", valid_578773
  var valid_578774 = query.getOrDefault("fields")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "fields", valid_578774
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

proc call*(call_578798: Call_LicensingLicenseAssignmentsInsert_578625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_578798.validator(path, query, header, formData, body)
  let scheme = call_578798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578798.url(scheme.get, call_578798.host, call_578798.base,
                         call_578798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578798, url, valid)

proc call*(call_578869: Call_LicensingLicenseAssignmentsInsert_578625;
          skuId: string; productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsInsert
  ## Assign License.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : Name for sku
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
  ##            : Name for product
  var path_578870 = newJObject()
  var query_578872 = newJObject()
  var body_578873 = newJObject()
  add(query_578872, "key", newJString(key))
  add(path_578870, "skuId", newJString(skuId))
  add(query_578872, "prettyPrint", newJBool(prettyPrint))
  add(query_578872, "oauth_token", newJString(oauthToken))
  add(query_578872, "alt", newJString(alt))
  add(query_578872, "userIp", newJString(userIp))
  add(query_578872, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578873 = body
  add(query_578872, "fields", newJString(fields))
  add(path_578870, "productId", newJString(productId))
  result = call_578869.call(path_578870, query_578872, nil, nil, body_578873)

var licensingLicenseAssignmentsInsert* = Call_LicensingLicenseAssignmentsInsert_578625(
    name: "licensingLicenseAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user",
    validator: validate_LicensingLicenseAssignmentsInsert_578626,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsInsert_578627, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsUpdate_578929 = ref object of OpenApiRestCall_578355
proc url_LicensingLicenseAssignmentsUpdate_578931(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsUpdate_578930(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign License.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku for which license would be revoked
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  ##   productId: JString (required)
  ##            : Name for product
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_578932 = path.getOrDefault("skuId")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "skuId", valid_578932
  var valid_578933 = path.getOrDefault("userId")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "userId", valid_578933
  var valid_578934 = path.getOrDefault("productId")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "productId", valid_578934
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
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("userIp")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "userIp", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
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

proc call*(call_578943: Call_LicensingLicenseAssignmentsUpdate_578929;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_LicensingLicenseAssignmentsUpdate_578929;
          skuId: string; userId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsUpdate
  ## Assign License.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : Name for sku for which license would be revoked
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
  ##         : email id or unique Id of the user
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : Name for product
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  var body_578947 = newJObject()
  add(query_578946, "key", newJString(key))
  add(path_578945, "skuId", newJString(skuId))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "userIp", newJString(userIp))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "userId", newJString(userId))
  if body != nil:
    body_578947 = body
  add(query_578946, "fields", newJString(fields))
  add(path_578945, "productId", newJString(productId))
  result = call_578944.call(path_578945, query_578946, nil, nil, body_578947)

var licensingLicenseAssignmentsUpdate* = Call_LicensingLicenseAssignmentsUpdate_578929(
    name: "licensingLicenseAssignmentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsUpdate_578930,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsUpdate_578931, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsGet_578912 = ref object of OpenApiRestCall_578355
proc url_LicensingLicenseAssignmentsGet_578914(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsGet_578913(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get license assignment of a particular product and sku for a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  ##   productId: JString (required)
  ##            : Name for product
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_578915 = path.getOrDefault("skuId")
  valid_578915 = validateParameter(valid_578915, JString, required = true,
                                 default = nil)
  if valid_578915 != nil:
    section.add "skuId", valid_578915
  var valid_578916 = path.getOrDefault("userId")
  valid_578916 = validateParameter(valid_578916, JString, required = true,
                                 default = nil)
  if valid_578916 != nil:
    section.add "userId", valid_578916
  var valid_578917 = path.getOrDefault("productId")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = nil)
  if valid_578917 != nil:
    section.add "productId", valid_578917
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
  var valid_578918 = query.getOrDefault("key")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "key", valid_578918
  var valid_578919 = query.getOrDefault("prettyPrint")
  valid_578919 = validateParameter(valid_578919, JBool, required = false,
                                 default = newJBool(true))
  if valid_578919 != nil:
    section.add "prettyPrint", valid_578919
  var valid_578920 = query.getOrDefault("oauth_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "oauth_token", valid_578920
  var valid_578921 = query.getOrDefault("alt")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("json"))
  if valid_578921 != nil:
    section.add "alt", valid_578921
  var valid_578922 = query.getOrDefault("userIp")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "userIp", valid_578922
  var valid_578923 = query.getOrDefault("quotaUser")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "quotaUser", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578925: Call_LicensingLicenseAssignmentsGet_578912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get license assignment of a particular product and sku for a user
  ## 
  let valid = call_578925.validator(path, query, header, formData, body)
  let scheme = call_578925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578925.url(scheme.get, call_578925.host, call_578925.base,
                         call_578925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578925, url, valid)

proc call*(call_578926: Call_LicensingLicenseAssignmentsGet_578912; skuId: string;
          userId: string; productId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsGet
  ## Get license assignment of a particular product and sku for a user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : Name for sku
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
  ##         : email id or unique Id of the user
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : Name for product
  var path_578927 = newJObject()
  var query_578928 = newJObject()
  add(query_578928, "key", newJString(key))
  add(path_578927, "skuId", newJString(skuId))
  add(query_578928, "prettyPrint", newJBool(prettyPrint))
  add(query_578928, "oauth_token", newJString(oauthToken))
  add(query_578928, "alt", newJString(alt))
  add(query_578928, "userIp", newJString(userIp))
  add(query_578928, "quotaUser", newJString(quotaUser))
  add(path_578927, "userId", newJString(userId))
  add(query_578928, "fields", newJString(fields))
  add(path_578927, "productId", newJString(productId))
  result = call_578926.call(path_578927, query_578928, nil, nil, nil)

var licensingLicenseAssignmentsGet* = Call_LicensingLicenseAssignmentsGet_578912(
    name: "licensingLicenseAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsGet_578913,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsGet_578914,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsPatch_578965 = ref object of OpenApiRestCall_578355
proc url_LicensingLicenseAssignmentsPatch_578967(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsPatch_578966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign License. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku for which license would be revoked
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  ##   productId: JString (required)
  ##            : Name for product
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_578968 = path.getOrDefault("skuId")
  valid_578968 = validateParameter(valid_578968, JString, required = true,
                                 default = nil)
  if valid_578968 != nil:
    section.add "skuId", valid_578968
  var valid_578969 = path.getOrDefault("userId")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = nil)
  if valid_578969 != nil:
    section.add "userId", valid_578969
  var valid_578970 = path.getOrDefault("productId")
  valid_578970 = validateParameter(valid_578970, JString, required = true,
                                 default = nil)
  if valid_578970 != nil:
    section.add "productId", valid_578970
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
  var valid_578971 = query.getOrDefault("key")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "key", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  var valid_578974 = query.getOrDefault("alt")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = newJString("json"))
  if valid_578974 != nil:
    section.add "alt", valid_578974
  var valid_578975 = query.getOrDefault("userIp")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "userIp", valid_578975
  var valid_578976 = query.getOrDefault("quotaUser")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "quotaUser", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
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

proc call*(call_578979: Call_LicensingLicenseAssignmentsPatch_578965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License. This method supports patch semantics.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_LicensingLicenseAssignmentsPatch_578965;
          skuId: string; userId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsPatch
  ## Assign License. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : Name for sku for which license would be revoked
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
  ##         : email id or unique Id of the user
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : Name for product
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(path_578981, "skuId", newJString(skuId))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "userIp", newJString(userIp))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "userId", newJString(userId))
  if body != nil:
    body_578983 = body
  add(query_578982, "fields", newJString(fields))
  add(path_578981, "productId", newJString(productId))
  result = call_578980.call(path_578981, query_578982, nil, nil, body_578983)

var licensingLicenseAssignmentsPatch* = Call_LicensingLicenseAssignmentsPatch_578965(
    name: "licensingLicenseAssignmentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsPatch_578966,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsPatch_578967,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsDelete_578948 = ref object of OpenApiRestCall_578355
proc url_LicensingLicenseAssignmentsDelete_578950(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsDelete_578949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revoke License.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skuId: JString (required)
  ##        : Name for sku
  ##   userId: JString (required)
  ##         : email id or unique Id of the user
  ##   productId: JString (required)
  ##            : Name for product
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skuId` field"
  var valid_578951 = path.getOrDefault("skuId")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "skuId", valid_578951
  var valid_578952 = path.getOrDefault("userId")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "userId", valid_578952
  var valid_578953 = path.getOrDefault("productId")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "productId", valid_578953
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
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("userIp")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "userIp", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578961: Call_LicensingLicenseAssignmentsDelete_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke License.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_LicensingLicenseAssignmentsDelete_578948;
          skuId: string; userId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## licensingLicenseAssignmentsDelete
  ## Revoke License.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : Name for sku
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
  ##         : email id or unique Id of the user
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : Name for product
  var path_578963 = newJObject()
  var query_578964 = newJObject()
  add(query_578964, "key", newJString(key))
  add(path_578963, "skuId", newJString(skuId))
  add(query_578964, "prettyPrint", newJBool(prettyPrint))
  add(query_578964, "oauth_token", newJString(oauthToken))
  add(query_578964, "alt", newJString(alt))
  add(query_578964, "userIp", newJString(userIp))
  add(query_578964, "quotaUser", newJString(quotaUser))
  add(path_578963, "userId", newJString(userId))
  add(query_578964, "fields", newJString(fields))
  add(path_578963, "productId", newJString(productId))
  result = call_578962.call(path_578963, query_578964, nil, nil, nil)

var licensingLicenseAssignmentsDelete* = Call_LicensingLicenseAssignmentsDelete_578948(
    name: "licensingLicenseAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsDelete_578949,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsDelete_578950, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProductAndSku_578984 = ref object of OpenApiRestCall_578355
proc url_LicensingLicenseAssignmentsListForProductAndSku_578986(protocol: Scheme;
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

proc validate_LicensingLicenseAssignmentsListForProductAndSku_578985(
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
  var valid_578987 = path.getOrDefault("skuId")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "skuId", valid_578987
  var valid_578988 = path.getOrDefault("productId")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "productId", valid_578988
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
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   customerId: JString (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  section = newJObject()
  var valid_578989 = query.getOrDefault("key")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "key", valid_578989
  var valid_578990 = query.getOrDefault("prettyPrint")
  valid_578990 = validateParameter(valid_578990, JBool, required = false,
                                 default = newJBool(true))
  if valid_578990 != nil:
    section.add "prettyPrint", valid_578990
  var valid_578991 = query.getOrDefault("oauth_token")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "oauth_token", valid_578991
  var valid_578992 = query.getOrDefault("alt")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = newJString("json"))
  if valid_578992 != nil:
    section.add "alt", valid_578992
  var valid_578993 = query.getOrDefault("userIp")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "userIp", valid_578993
  var valid_578994 = query.getOrDefault("quotaUser")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "quotaUser", valid_578994
  var valid_578995 = query.getOrDefault("pageToken")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString(""))
  if valid_578995 != nil:
    section.add "pageToken", valid_578995
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_578996 = query.getOrDefault("customerId")
  valid_578996 = validateParameter(valid_578996, JString, required = true,
                                 default = nil)
  if valid_578996 != nil:
    section.add "customerId", valid_578996
  var valid_578997 = query.getOrDefault("fields")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "fields", valid_578997
  var valid_578999 = query.getOrDefault("maxResults")
  valid_578999 = validateParameter(valid_578999, JInt, required = false,
                                 default = newJInt(100))
  if valid_578999 != nil:
    section.add "maxResults", valid_578999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579000: Call_LicensingLicenseAssignmentsListForProductAndSku_578984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product and sku of the customer.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_LicensingLicenseAssignmentsListForProductAndSku_578984;
          skuId: string; customerId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 100): Recallable =
  ## licensingLicenseAssignmentsListForProductAndSku
  ## List license assignments for given product and sku of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   skuId: string (required)
  ##        : Name for sku
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
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   customerId: string (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : Name for product
  ##   maxResults: int
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  add(query_579003, "key", newJString(key))
  add(path_579002, "skuId", newJString(skuId))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "userIp", newJString(userIp))
  add(query_579003, "quotaUser", newJString(quotaUser))
  add(query_579003, "pageToken", newJString(pageToken))
  add(query_579003, "customerId", newJString(customerId))
  add(query_579003, "fields", newJString(fields))
  add(path_579002, "productId", newJString(productId))
  add(query_579003, "maxResults", newJInt(maxResults))
  result = call_579001.call(path_579002, query_579003, nil, nil, nil)

var licensingLicenseAssignmentsListForProductAndSku* = Call_LicensingLicenseAssignmentsListForProductAndSku_578984(
    name: "licensingLicenseAssignmentsListForProductAndSku",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{productId}/sku/{skuId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProductAndSku_578985,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProductAndSku_578986,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProduct_579004 = ref object of OpenApiRestCall_578355
proc url_LicensingLicenseAssignmentsListForProduct_579006(protocol: Scheme;
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

proc validate_LicensingLicenseAssignmentsListForProduct_579005(path: JsonNode;
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
  var valid_579007 = path.getOrDefault("productId")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "productId", valid_579007
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
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   customerId: JString (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  section = newJObject()
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("userIp")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "userIp", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("pageToken")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString(""))
  if valid_579014 != nil:
    section.add "pageToken", valid_579014
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_579015 = query.getOrDefault("customerId")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "customerId", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("maxResults")
  valid_579017 = validateParameter(valid_579017, JInt, required = false,
                                 default = newJInt(100))
  if valid_579017 != nil:
    section.add "maxResults", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579018: Call_LicensingLicenseAssignmentsListForProduct_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product of the customer.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_LicensingLicenseAssignmentsListForProduct_579004;
          customerId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 100): Recallable =
  ## licensingLicenseAssignmentsListForProduct
  ## List license assignments for given product of the customer.
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
  ##            : Token to fetch the next page.Optional. By default server will return first page
  ##   customerId: string (required)
  ##             : CustomerId represents the customer for whom licenseassignments are queried
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : Name for product
  ##   maxResults: int
  ##             : Maximum number of campaigns to return at one time. Must be positive. Optional. Default value is 100.
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(query_579021, "pageToken", newJString(pageToken))
  add(query_579021, "customerId", newJString(customerId))
  add(query_579021, "fields", newJString(fields))
  add(path_579020, "productId", newJString(productId))
  add(query_579021, "maxResults", newJInt(maxResults))
  result = call_579019.call(path_579020, query_579021, nil, nil, nil)

var licensingLicenseAssignmentsListForProduct* = Call_LicensingLicenseAssignmentsListForProduct_579004(
    name: "licensingLicenseAssignmentsListForProduct", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProduct_579005,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProduct_579006,
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
