
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LicensingLicenseAssignmentsInsert_593692 = ref object of OpenApiRestCall_593424
proc url_LicensingLicenseAssignmentsInsert_593694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LicensingLicenseAssignmentsInsert_593693(path: JsonNode;
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
  var valid_593820 = path.getOrDefault("skuId")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "skuId", valid_593820
  var valid_593821 = path.getOrDefault("productId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "productId", valid_593821
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
  var valid_593822 = query.getOrDefault("fields")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "fields", valid_593822
  var valid_593823 = query.getOrDefault("quotaUser")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "quotaUser", valid_593823
  var valid_593837 = query.getOrDefault("alt")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = newJString("json"))
  if valid_593837 != nil:
    section.add "alt", valid_593837
  var valid_593838 = query.getOrDefault("oauth_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "oauth_token", valid_593838
  var valid_593839 = query.getOrDefault("userIp")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "userIp", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("prettyPrint")
  valid_593841 = validateParameter(valid_593841, JBool, required = false,
                                 default = newJBool(true))
  if valid_593841 != nil:
    section.add "prettyPrint", valid_593841
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

proc call*(call_593865: Call_LicensingLicenseAssignmentsInsert_593692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_LicensingLicenseAssignmentsInsert_593692;
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  var body_593940 = newJObject()
  add(path_593937, "skuId", newJString(skuId))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "userIp", newJString(userIp))
  add(query_593939, "key", newJString(key))
  if body != nil:
    body_593940 = body
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  add(path_593937, "productId", newJString(productId))
  result = call_593936.call(path_593937, query_593939, nil, nil, body_593940)

var licensingLicenseAssignmentsInsert* = Call_LicensingLicenseAssignmentsInsert_593692(
    name: "licensingLicenseAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user",
    validator: validate_LicensingLicenseAssignmentsInsert_593693,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsInsert_593694, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsUpdate_593996 = ref object of OpenApiRestCall_593424
proc url_LicensingLicenseAssignmentsUpdate_593998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LicensingLicenseAssignmentsUpdate_593997(path: JsonNode;
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
  var valid_593999 = path.getOrDefault("skuId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "skuId", valid_593999
  var valid_594000 = path.getOrDefault("productId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "productId", valid_594000
  var valid_594001 = path.getOrDefault("userId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "userId", valid_594001
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
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("userIp")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "userIp", valid_594006
  var valid_594007 = query.getOrDefault("key")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "key", valid_594007
  var valid_594008 = query.getOrDefault("prettyPrint")
  valid_594008 = validateParameter(valid_594008, JBool, required = false,
                                 default = newJBool(true))
  if valid_594008 != nil:
    section.add "prettyPrint", valid_594008
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

proc call*(call_594010: Call_LicensingLicenseAssignmentsUpdate_593996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_LicensingLicenseAssignmentsUpdate_593996;
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
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  var body_594014 = newJObject()
  add(path_594012, "skuId", newJString(skuId))
  add(query_594013, "fields", newJString(fields))
  add(query_594013, "quotaUser", newJString(quotaUser))
  add(query_594013, "alt", newJString(alt))
  add(query_594013, "oauth_token", newJString(oauthToken))
  add(query_594013, "userIp", newJString(userIp))
  add(query_594013, "key", newJString(key))
  if body != nil:
    body_594014 = body
  add(query_594013, "prettyPrint", newJBool(prettyPrint))
  add(path_594012, "productId", newJString(productId))
  add(path_594012, "userId", newJString(userId))
  result = call_594011.call(path_594012, query_594013, nil, nil, body_594014)

var licensingLicenseAssignmentsUpdate* = Call_LicensingLicenseAssignmentsUpdate_593996(
    name: "licensingLicenseAssignmentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsUpdate_593997,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsUpdate_593998, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsGet_593979 = ref object of OpenApiRestCall_593424
proc url_LicensingLicenseAssignmentsGet_593981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LicensingLicenseAssignmentsGet_593980(path: JsonNode;
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
  var valid_593982 = path.getOrDefault("skuId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "skuId", valid_593982
  var valid_593983 = path.getOrDefault("productId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "productId", valid_593983
  var valid_593984 = path.getOrDefault("userId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "userId", valid_593984
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
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("quotaUser")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "quotaUser", valid_593986
  var valid_593987 = query.getOrDefault("alt")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("json"))
  if valid_593987 != nil:
    section.add "alt", valid_593987
  var valid_593988 = query.getOrDefault("oauth_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "oauth_token", valid_593988
  var valid_593989 = query.getOrDefault("userIp")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "userIp", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("prettyPrint")
  valid_593991 = validateParameter(valid_593991, JBool, required = false,
                                 default = newJBool(true))
  if valid_593991 != nil:
    section.add "prettyPrint", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_LicensingLicenseAssignmentsGet_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get license assignment of a particular product and sku for a user
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_LicensingLicenseAssignmentsGet_593979; skuId: string;
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
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(path_593994, "skuId", newJString(skuId))
  add(query_593995, "fields", newJString(fields))
  add(query_593995, "quotaUser", newJString(quotaUser))
  add(query_593995, "alt", newJString(alt))
  add(query_593995, "oauth_token", newJString(oauthToken))
  add(query_593995, "userIp", newJString(userIp))
  add(query_593995, "key", newJString(key))
  add(path_593994, "productId", newJString(productId))
  add(query_593995, "prettyPrint", newJBool(prettyPrint))
  add(path_593994, "userId", newJString(userId))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var licensingLicenseAssignmentsGet* = Call_LicensingLicenseAssignmentsGet_593979(
    name: "licensingLicenseAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsGet_593980,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsGet_593981,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsPatch_594032 = ref object of OpenApiRestCall_593424
proc url_LicensingLicenseAssignmentsPatch_594034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LicensingLicenseAssignmentsPatch_594033(path: JsonNode;
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
  var valid_594035 = path.getOrDefault("skuId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "skuId", valid_594035
  var valid_594036 = path.getOrDefault("productId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "productId", valid_594036
  var valid_594037 = path.getOrDefault("userId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "userId", valid_594037
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
  var valid_594038 = query.getOrDefault("fields")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "fields", valid_594038
  var valid_594039 = query.getOrDefault("quotaUser")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "quotaUser", valid_594039
  var valid_594040 = query.getOrDefault("alt")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("json"))
  if valid_594040 != nil:
    section.add "alt", valid_594040
  var valid_594041 = query.getOrDefault("oauth_token")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "oauth_token", valid_594041
  var valid_594042 = query.getOrDefault("userIp")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "userIp", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("prettyPrint")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "prettyPrint", valid_594044
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

proc call*(call_594046: Call_LicensingLicenseAssignmentsPatch_594032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Assign License. This method supports patch semantics.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_LicensingLicenseAssignmentsPatch_594032;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(path_594048, "skuId", newJString(skuId))
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(query_594049, "userIp", newJString(userIp))
  add(query_594049, "key", newJString(key))
  if body != nil:
    body_594050 = body
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  add(path_594048, "productId", newJString(productId))
  add(path_594048, "userId", newJString(userId))
  result = call_594047.call(path_594048, query_594049, nil, nil, body_594050)

var licensingLicenseAssignmentsPatch* = Call_LicensingLicenseAssignmentsPatch_594032(
    name: "licensingLicenseAssignmentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsPatch_594033,
    base: "/apps/licensing/v1/product", url: url_LicensingLicenseAssignmentsPatch_594034,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsDelete_594015 = ref object of OpenApiRestCall_593424
proc url_LicensingLicenseAssignmentsDelete_594017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LicensingLicenseAssignmentsDelete_594016(path: JsonNode;
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
  var valid_594018 = path.getOrDefault("skuId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "skuId", valid_594018
  var valid_594019 = path.getOrDefault("productId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "productId", valid_594019
  var valid_594020 = path.getOrDefault("userId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "userId", valid_594020
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
  var valid_594021 = query.getOrDefault("fields")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "fields", valid_594021
  var valid_594022 = query.getOrDefault("quotaUser")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "quotaUser", valid_594022
  var valid_594023 = query.getOrDefault("alt")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("json"))
  if valid_594023 != nil:
    section.add "alt", valid_594023
  var valid_594024 = query.getOrDefault("oauth_token")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "oauth_token", valid_594024
  var valid_594025 = query.getOrDefault("userIp")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "userIp", valid_594025
  var valid_594026 = query.getOrDefault("key")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "key", valid_594026
  var valid_594027 = query.getOrDefault("prettyPrint")
  valid_594027 = validateParameter(valid_594027, JBool, required = false,
                                 default = newJBool(true))
  if valid_594027 != nil:
    section.add "prettyPrint", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_LicensingLicenseAssignmentsDelete_594015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke License.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_LicensingLicenseAssignmentsDelete_594015;
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
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(path_594030, "skuId", newJString(skuId))
  add(query_594031, "fields", newJString(fields))
  add(query_594031, "quotaUser", newJString(quotaUser))
  add(query_594031, "alt", newJString(alt))
  add(query_594031, "oauth_token", newJString(oauthToken))
  add(query_594031, "userIp", newJString(userIp))
  add(query_594031, "key", newJString(key))
  add(path_594030, "productId", newJString(productId))
  add(query_594031, "prettyPrint", newJBool(prettyPrint))
  add(path_594030, "userId", newJString(userId))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var licensingLicenseAssignmentsDelete* = Call_LicensingLicenseAssignmentsDelete_594015(
    name: "licensingLicenseAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{productId}/sku/{skuId}/user/{userId}",
    validator: validate_LicensingLicenseAssignmentsDelete_594016,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsDelete_594017, schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProductAndSku_594051 = ref object of OpenApiRestCall_593424
proc url_LicensingLicenseAssignmentsListForProductAndSku_594053(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LicensingLicenseAssignmentsListForProductAndSku_594052(
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
  var valid_594054 = path.getOrDefault("skuId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "skuId", valid_594054
  var valid_594055 = path.getOrDefault("productId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "productId", valid_594055
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
  var valid_594056 = query.getOrDefault("fields")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "fields", valid_594056
  var valid_594057 = query.getOrDefault("pageToken")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString(""))
  if valid_594057 != nil:
    section.add "pageToken", valid_594057
  var valid_594058 = query.getOrDefault("quotaUser")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "quotaUser", valid_594058
  var valid_594059 = query.getOrDefault("alt")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("json"))
  if valid_594059 != nil:
    section.add "alt", valid_594059
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_594060 = query.getOrDefault("customerId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "customerId", valid_594060
  var valid_594061 = query.getOrDefault("oauth_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "oauth_token", valid_594061
  var valid_594062 = query.getOrDefault("userIp")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "userIp", valid_594062
  var valid_594064 = query.getOrDefault("maxResults")
  valid_594064 = validateParameter(valid_594064, JInt, required = false,
                                 default = newJInt(100))
  if valid_594064 != nil:
    section.add "maxResults", valid_594064
  var valid_594065 = query.getOrDefault("key")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "key", valid_594065
  var valid_594066 = query.getOrDefault("prettyPrint")
  valid_594066 = validateParameter(valid_594066, JBool, required = false,
                                 default = newJBool(true))
  if valid_594066 != nil:
    section.add "prettyPrint", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_LicensingLicenseAssignmentsListForProductAndSku_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product and sku of the customer.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_LicensingLicenseAssignmentsListForProductAndSku_594051;
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "skuId", newJString(skuId))
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "pageToken", newJString(pageToken))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "alt", newJString(alt))
  add(query_594070, "customerId", newJString(customerId))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "userIp", newJString(userIp))
  add(query_594070, "maxResults", newJInt(maxResults))
  add(query_594070, "key", newJString(key))
  add(path_594069, "productId", newJString(productId))
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var licensingLicenseAssignmentsListForProductAndSku* = Call_LicensingLicenseAssignmentsListForProductAndSku_594051(
    name: "licensingLicenseAssignmentsListForProductAndSku",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{productId}/sku/{skuId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProductAndSku_594052,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProductAndSku_594053,
    schemes: {Scheme.Https})
type
  Call_LicensingLicenseAssignmentsListForProduct_594071 = ref object of OpenApiRestCall_593424
proc url_LicensingLicenseAssignmentsListForProduct_594073(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LicensingLicenseAssignmentsListForProduct_594072(path: JsonNode;
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
  var valid_594074 = path.getOrDefault("productId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "productId", valid_594074
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
  var valid_594075 = query.getOrDefault("fields")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "fields", valid_594075
  var valid_594076 = query.getOrDefault("pageToken")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = newJString(""))
  if valid_594076 != nil:
    section.add "pageToken", valid_594076
  var valid_594077 = query.getOrDefault("quotaUser")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "quotaUser", valid_594077
  var valid_594078 = query.getOrDefault("alt")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("json"))
  if valid_594078 != nil:
    section.add "alt", valid_594078
  assert query != nil,
        "query argument is necessary due to required `customerId` field"
  var valid_594079 = query.getOrDefault("customerId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "customerId", valid_594079
  var valid_594080 = query.getOrDefault("oauth_token")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "oauth_token", valid_594080
  var valid_594081 = query.getOrDefault("userIp")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "userIp", valid_594081
  var valid_594082 = query.getOrDefault("maxResults")
  valid_594082 = validateParameter(valid_594082, JInt, required = false,
                                 default = newJInt(100))
  if valid_594082 != nil:
    section.add "maxResults", valid_594082
  var valid_594083 = query.getOrDefault("key")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "key", valid_594083
  var valid_594084 = query.getOrDefault("prettyPrint")
  valid_594084 = validateParameter(valid_594084, JBool, required = false,
                                 default = newJBool(true))
  if valid_594084 != nil:
    section.add "prettyPrint", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_LicensingLicenseAssignmentsListForProduct_594071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List license assignments for given product of the customer.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_LicensingLicenseAssignmentsListForProduct_594071;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(query_594088, "fields", newJString(fields))
  add(query_594088, "pageToken", newJString(pageToken))
  add(query_594088, "quotaUser", newJString(quotaUser))
  add(query_594088, "alt", newJString(alt))
  add(query_594088, "customerId", newJString(customerId))
  add(query_594088, "oauth_token", newJString(oauthToken))
  add(query_594088, "userIp", newJString(userIp))
  add(query_594088, "maxResults", newJInt(maxResults))
  add(query_594088, "key", newJString(key))
  add(path_594087, "productId", newJString(productId))
  add(query_594088, "prettyPrint", newJBool(prettyPrint))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var licensingLicenseAssignmentsListForProduct* = Call_LicensingLicenseAssignmentsListForProduct_594071(
    name: "licensingLicenseAssignmentsListForProduct", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{productId}/users",
    validator: validate_LicensingLicenseAssignmentsListForProduct_594072,
    base: "/apps/licensing/v1/product",
    url: url_LicensingLicenseAssignmentsListForProduct_594073,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
