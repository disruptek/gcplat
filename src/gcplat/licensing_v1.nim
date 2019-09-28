
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  gcpServiceName = "licensing"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LicensingLicenseAssignmentsInsert_579692 = ref object of OpenApiRestCall_579424
proc url_LicensingLicenseAssignmentsInsert_579694(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsInsert_579693(path: JsonNode;
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
  var valid_579820 = path.getOrDefault("skuId")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "skuId", valid_579820
  var valid_579821 = path.getOrDefault("productId")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "productId", valid_579821
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
  var valid_579822 = query.getOrDefault("fields")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "fields", valid_579822
  var valid_579823 = query.getOrDefault("quotaUser")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "quotaUser", valid_579823
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("userIp")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "userIp", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("prettyPrint")
  valid_579841 = validateParameter(valid_579841, JBool, required = false,
                                 default = newJBool(true))
  if valid_579841 != nil:
    section.add "prettyPrint", valid_579841
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

proc call*(call_579865: Call_LicensingLicenseAssignmentsInsert_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_LicensingLicenseAssignmentsInsert_579692;
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
  var path_579937 = newJObject()
  var query_579939 = newJObject()
  var body_579940 = newJObject()
  add(path_579937, "skuId", newJString(skuId))
  add(query_579939, "fields", newJString(fields))
  add(query_579939, "quotaUser", newJString(quotaUser))
  add(query_579939, "alt", newJString(alt))
  add(query_579939, "oauth_token", newJString(oauthToken))
  add(query_579939, "userIp", newJString(userIp))
  add(query_579939, "key", newJString(key))
  if body != nil:
    body_579940 = body
  add(query_579939, "prettyPrint", newJBool(prettyPrint))
  add(path_579937, "productId", newJString(productId))
  result = call_579936.call(path_579937, query_579939, nil, nil, body_579940)

var licensingLicenseAssignmentsInsert* = Call_LicensingLicenseAssignmentsInsert_579692(
    name: "licensingLicenseAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user",
    validator: validate_LicensingLicenseAssignmentsInsert_579693,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsInsert_579694, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsUpdate_579996 = ref object of OpenApiRestCall_579424
proc url_LicensingLicenseAssignmentsUpdate_579998(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsUpdate_579997(path: JsonNode;
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
  var valid_579999 = path.getOrDefault("skuId")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = nil)
  if valid_579999 != nil:
    section.add "skuId", valid_579999
  var valid_580000 = path.getOrDefault("productId")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "productId", valid_580000
  var valid_580001 = path.getOrDefault("userId")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "userId", valid_580001
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
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("userIp")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "userIp", valid_580006
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
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

proc call*(call_580010: Call_LicensingLicenseAssignmentsUpdate_579996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_LicensingLicenseAssignmentsUpdate_579996;
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
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  var body_580014 = newJObject()
  add(path_580012, "skuId", newJString(skuId))
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "quotaUser", newJString(quotaUser))
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(query_580013, "userIp", newJString(userIp))
  add(query_580013, "key", newJString(key))
  if body != nil:
    body_580014 = body
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  add(path_580012, "productId", newJString(productId))
  add(path_580012, "userId", newJString(userId))
  result = call_580011.call(path_580012, query_580013, nil, nil, body_580014)

var licensingLicenseAssignmentsUpdate* = Call_LicensingLicenseAssignmentsUpdate_579996(
    name: "licensingLicenseAssignmentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsUpdate_579997,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsUpdate_579998, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsGet_579979 = ref object of OpenApiRestCall_579424
proc url_LicensingLicenseAssignmentsGet_579981(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsGet_579980(path: JsonNode;
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
  var valid_579982 = path.getOrDefault("skuId")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "skuId", valid_579982
  var valid_579983 = path.getOrDefault("productId")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "productId", valid_579983
  var valid_579984 = path.getOrDefault("userId")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "userId", valid_579984
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
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("userIp")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "userIp", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579992: Call_LicensingLicenseAssignmentsGet_579979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get license assignment of a particular product and sku for a user
  ## 
  let valid = call_579992.validator(path, query, header, formData, body)
  let scheme = call_579992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579992.url(scheme.get, call_579992.host, call_579992.base,
                         call_579992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579992, url, valid)

proc call*(call_579993: Call_LicensingLicenseAssignmentsGet_579979; skuId: string;
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
  var path_579994 = newJObject()
  var query_579995 = newJObject()
  add(path_579994, "skuId", newJString(skuId))
  add(query_579995, "fields", newJString(fields))
  add(query_579995, "quotaUser", newJString(quotaUser))
  add(query_579995, "alt", newJString(alt))
  add(query_579995, "oauth_token", newJString(oauthToken))
  add(query_579995, "userIp", newJString(userIp))
  add(query_579995, "key", newJString(key))
  add(path_579994, "productId", newJString(productId))
  add(query_579995, "prettyPrint", newJBool(prettyPrint))
  add(path_579994, "userId", newJString(userId))
  result = call_579993.call(path_579994, query_579995, nil, nil, nil)

var licensingLicenseAssignmentsGet* = Call_LicensingLicenseAssignmentsGet_579979(
    name: "licensingLicenseAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsGet_579980,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsGet_579981,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsPatch_580032 = ref object of OpenApiRestCall_579424
proc url_LicensingLicenseAssignmentsPatch_580034(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsPatch_580033(path: JsonNode;
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
  var valid_580035 = path.getOrDefault("skuId")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "skuId", valid_580035
  var valid_580036 = path.getOrDefault("productId")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "productId", valid_580036
  var valid_580037 = path.getOrDefault("userId")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userId", valid_580037
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
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("quotaUser")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "quotaUser", valid_580039
  var valid_580040 = query.getOrDefault("alt")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("json"))
  if valid_580040 != nil:
    section.add "alt", valid_580040
  var valid_580041 = query.getOrDefault("oauth_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "oauth_token", valid_580041
  var valid_580042 = query.getOrDefault("userIp")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "userIp", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
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

proc call*(call_580046: Call_LicensingLicenseAssignmentsPatch_580032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License. This method supports patch semantics.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_LicensingLicenseAssignmentsPatch_580032;
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  var body_580050 = newJObject()
  add(path_580048, "skuId", newJString(skuId))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "key", newJString(key))
  if body != nil:
    body_580050 = body
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  add(path_580048, "productId", newJString(productId))
  add(path_580048, "userId", newJString(userId))
  result = call_580047.call(path_580048, query_580049, nil, nil, body_580050)

var licensingLicenseAssignmentsPatch* = Call_LicensingLicenseAssignmentsPatch_580032(
    name: "licensingLicenseAssignmentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsPatch_580033,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsPatch_580034,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsDelete_580015 = ref object of OpenApiRestCall_579424
proc url_LicensingLicenseAssignmentsDelete_580017(protocol: Scheme; host: string;
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

proc validate_LicensingLicenseAssignmentsDelete_580016(path: JsonNode;
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
  var valid_580018 = path.getOrDefault("skuId")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "skuId", valid_580018
  var valid_580019 = path.getOrDefault("productId")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "productId", valid_580019
  var valid_580020 = path.getOrDefault("userId")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "userId", valid_580020
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
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("userIp")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "userIp", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580028: Call_LicensingLicenseAssignmentsDelete_580015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke License.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_LicensingLicenseAssignmentsDelete_580015;
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
  var path_580030 = newJObject()
  var query_580031 = newJObject()
  add(path_580030, "skuId", newJString(skuId))
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(query_580031, "userIp", newJString(userIp))
  add(query_580031, "key", newJString(key))
  add(path_580030, "productId", newJString(productId))
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  add(path_580030, "userId", newJString(userId))
  result = call_580029.call(path_580030, query_580031, nil, nil, nil)

var licensingLicenseAssignmentsDelete* = Call_LicensingLicenseAssignmentsDelete_580015(
    name: "licensingLicenseAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsDelete_580016,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsDelete_580017, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProductAndSku_580051 = ref object of OpenApiRestCall_579424
proc url_LicensingLicenseAssignmentsListForProductAndSku_580053(protocol: Scheme;
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

proc validate_LicensingLicenseAssignmentsListForProductAndSku_580052(
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
  var valid_580054 = path.getOrDefault("skuId")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "skuId", valid_580054
  var valid_580055 = path.getOrDefault("productId")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "productId", valid_580055
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
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("pageToken")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString(""))
  if valid_580057 != nil:
    section.add "pageToken", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_580060 = query.getOrDefault("customerId")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "customerId", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("userIp")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "userIp", valid_580062
  var valid_580064 = query.getOrDefault("maxResults")
  valid_580064 = validateParameter(valid_580064, JInt, required = false,
                                 default = newJInt(100))
  if valid_580064 != nil:
    section.add "maxResults", valid_580064
  var valid_580065 = query.getOrDefault("key")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "key", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580067: Call_LicensingLicenseAssignmentsListForProductAndSku_580051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product and sku of the customer.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_LicensingLicenseAssignmentsListForProductAndSku_580051;
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
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  add(path_580069, "skuId", newJString(skuId))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "pageToken", newJString(pageToken))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "customerId", newJString(customerId))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "maxResults", newJInt(maxResults))
  add(query_580070, "key", newJString(key))
  add(path_580069, "productId", newJString(productId))
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, nil)

var licensingLicenseAssignmentsListForProductAndSku* = Call_LicensingLicenseAssignmentsListForProductAndSku_580051(
    name: "licensingLicenseAssignmentsListForProductAndSku",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{productId}/sku/{skuId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProductAndSku_580052,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProductAndSku_580053,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProduct_580071 = ref object of OpenApiRestCall_579424
proc url_LicensingLicenseAssignmentsListForProduct_580073(protocol: Scheme;
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

proc validate_LicensingLicenseAssignmentsListForProduct_580072(path: JsonNode;
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
  var valid_580074 = path.getOrDefault("productId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "productId", valid_580074
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
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("pageToken")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString(""))
  if valid_580076 != nil:
    section.add "pageToken", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_580079 = query.getOrDefault("customerId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "customerId", valid_580079
  var valid_580080 = query.getOrDefault("oauth_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "oauth_token", valid_580080
  var valid_580081 = query.getOrDefault("userIp")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "userIp", valid_580081
  var valid_580082 = query.getOrDefault("maxResults")
  valid_580082 = validateParameter(valid_580082, JInt, required = false,
                                 default = newJInt(100))
  if valid_580082 != nil:
    section.add "maxResults", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_LicensingLicenseAssignmentsListForProduct_580071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product of the customer.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_LicensingLicenseAssignmentsListForProduct_580071;
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
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "pageToken", newJString(pageToken))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "customerId", newJString(customerId))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "maxResults", newJInt(maxResults))
  add(query_580088, "key", newJString(key))
  add(path_580087, "productId", newJString(productId))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var licensingLicenseAssignmentsListForProduct* = Call_LicensingLicenseAssignmentsListForProduct_580071(
    name: "licensingLicenseAssignmentsListForProduct", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProduct_580072,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProduct_580073,
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
