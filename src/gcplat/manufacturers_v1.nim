
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Manufacturer Center
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Public API for managing Manufacturer Center related data.
## 
## https://developers.google.com/manufacturers/
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
  gcpServiceName = "manufacturers"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManufacturersAccountsProductsList_588710 = ref object of OpenApiRestCall_588441
proc url_ManufacturersAccountsProductsList_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManufacturersAccountsProductsList_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the products in a Manufacturer Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_588838 = path.getOrDefault("parent")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "parent", valid_588838
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of product statuses to return in the response, used for
  ## paging.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("pageToken")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "pageToken", valid_588841
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
  var valid_588858 = query.getOrDefault("callback")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "callback", valid_588858
  var valid_588859 = query.getOrDefault("access_token")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "access_token", valid_588859
  var valid_588860 = query.getOrDefault("uploadType")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "uploadType", valid_588860
  var valid_588861 = query.getOrDefault("include")
  valid_588861 = validateParameter(valid_588861, JArray, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "include", valid_588861
  var valid_588862 = query.getOrDefault("key")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = nil)
  if valid_588862 != nil:
    section.add "key", valid_588862
  var valid_588863 = query.getOrDefault("$.xgafv")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("1"))
  if valid_588863 != nil:
    section.add "$.xgafv", valid_588863
  var valid_588864 = query.getOrDefault("pageSize")
  valid_588864 = validateParameter(valid_588864, JInt, required = false, default = nil)
  if valid_588864 != nil:
    section.add "pageSize", valid_588864
  var valid_588865 = query.getOrDefault("prettyPrint")
  valid_588865 = validateParameter(valid_588865, JBool, required = false,
                                 default = newJBool(true))
  if valid_588865 != nil:
    section.add "prettyPrint", valid_588865
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588888: Call_ManufacturersAccountsProductsList_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the products in a Manufacturer Center account.
  ## 
  let valid = call_588888.validator(path, query, header, formData, body)
  let scheme = call_588888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588888.url(scheme.get, call_588888.host, call_588888.base,
                         call_588888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588888, url, valid)

proc call*(call_588959: Call_ManufacturersAccountsProductsList_588710;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; `include`: JsonNode = nil; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## manufacturersAccountsProductsList
  ## Lists all the products in a Manufacturer Center account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of product statuses to return in the response, used for
  ## paging.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588960 = newJObject()
  var query_588962 = newJObject()
  add(query_588962, "upload_protocol", newJString(uploadProtocol))
  add(query_588962, "fields", newJString(fields))
  add(query_588962, "pageToken", newJString(pageToken))
  add(query_588962, "quotaUser", newJString(quotaUser))
  add(query_588962, "alt", newJString(alt))
  add(query_588962, "oauth_token", newJString(oauthToken))
  add(query_588962, "callback", newJString(callback))
  add(query_588962, "access_token", newJString(accessToken))
  add(query_588962, "uploadType", newJString(uploadType))
  add(path_588960, "parent", newJString(parent))
  if `include` != nil:
    query_588962.add "include", `include`
  add(query_588962, "key", newJString(key))
  add(query_588962, "$.xgafv", newJString(Xgafv))
  add(query_588962, "pageSize", newJInt(pageSize))
  add(query_588962, "prettyPrint", newJBool(prettyPrint))
  result = call_588959.call(path_588960, query_588962, nil, nil, nil)

var manufacturersAccountsProductsList* = Call_ManufacturersAccountsProductsList_588710(
    name: "manufacturersAccountsProductsList", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_ManufacturersAccountsProductsList_588711, base: "/",
    url: url_ManufacturersAccountsProductsList_588712, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsUpdate_589022 = ref object of OpenApiRestCall_588441
proc url_ManufacturersAccountsProductsUpdate_589024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManufacturersAccountsProductsUpdate_589023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts or updates the attributes of the product in a Manufacturer Center
  ## account.
  ## 
  ## Creates a product with the provided attributes. If the product already
  ## exists, then all attributes are replaced with the new ones. The checks at
  ## upload time are minimal. All required attributes need to be present for a
  ## product to be valid. Issues may show up later after the API has accepted a
  ## new upload for a product and it is possible to overwrite an existing valid
  ## product with an invalid product. To detect this, you should retrieve the
  ## product and check it for issues once the new version is available.
  ## 
  ## Uploaded attributes first need to be processed before they can be
  ## retrieved. Until then, new products will be unavailable, and retrieval
  ## of previously uploaded products will return the original state of the
  ## product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name in the format `{target_country}:{content_language}:{product_id}`.
  ## 
  ## `target_country`   - The target country of the product as a CLDR territory
  ##                      code (for example, US).
  ## 
  ## `content_language` - The content language of the product as a two-letter
  ##                      ISO 639-1 language code (for example, en).
  ## 
  ## `product_id`     -   The ID of the product. For more information, see
  ##                      https://support.google.com/manufacturers/answer/6124116#id.
  ##   parent: JString (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589025 = path.getOrDefault("name")
  valid_589025 = validateParameter(valid_589025, JString, required = true,
                                 default = nil)
  if valid_589025 != nil:
    section.add "name", valid_589025
  var valid_589026 = path.getOrDefault("parent")
  valid_589026 = validateParameter(valid_589026, JString, required = true,
                                 default = nil)
  if valid_589026 != nil:
    section.add "parent", valid_589026
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589027 = query.getOrDefault("upload_protocol")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "upload_protocol", valid_589027
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("quotaUser")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "quotaUser", valid_589029
  var valid_589030 = query.getOrDefault("alt")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("json"))
  if valid_589030 != nil:
    section.add "alt", valid_589030
  var valid_589031 = query.getOrDefault("oauth_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "oauth_token", valid_589031
  var valid_589032 = query.getOrDefault("callback")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "callback", valid_589032
  var valid_589033 = query.getOrDefault("access_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "access_token", valid_589033
  var valid_589034 = query.getOrDefault("uploadType")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "uploadType", valid_589034
  var valid_589035 = query.getOrDefault("key")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "key", valid_589035
  var valid_589036 = query.getOrDefault("$.xgafv")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("1"))
  if valid_589036 != nil:
    section.add "$.xgafv", valid_589036
  var valid_589037 = query.getOrDefault("prettyPrint")
  valid_589037 = validateParameter(valid_589037, JBool, required = false,
                                 default = newJBool(true))
  if valid_589037 != nil:
    section.add "prettyPrint", valid_589037
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

proc call*(call_589039: Call_ManufacturersAccountsProductsUpdate_589022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts or updates the attributes of the product in a Manufacturer Center
  ## account.
  ## 
  ## Creates a product with the provided attributes. If the product already
  ## exists, then all attributes are replaced with the new ones. The checks at
  ## upload time are minimal. All required attributes need to be present for a
  ## product to be valid. Issues may show up later after the API has accepted a
  ## new upload for a product and it is possible to overwrite an existing valid
  ## product with an invalid product. To detect this, you should retrieve the
  ## product and check it for issues once the new version is available.
  ## 
  ## Uploaded attributes first need to be processed before they can be
  ## retrieved. Until then, new products will be unavailable, and retrieval
  ## of previously uploaded products will return the original state of the
  ## product.
  ## 
  let valid = call_589039.validator(path, query, header, formData, body)
  let scheme = call_589039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589039.url(scheme.get, call_589039.host, call_589039.base,
                         call_589039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589039, url, valid)

proc call*(call_589040: Call_ManufacturersAccountsProductsUpdate_589022;
          name: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## manufacturersAccountsProductsUpdate
  ## Inserts or updates the attributes of the product in a Manufacturer Center
  ## account.
  ## 
  ## Creates a product with the provided attributes. If the product already
  ## exists, then all attributes are replaced with the new ones. The checks at
  ## upload time are minimal. All required attributes need to be present for a
  ## product to be valid. Issues may show up later after the API has accepted a
  ## new upload for a product and it is possible to overwrite an existing valid
  ## product with an invalid product. To detect this, you should retrieve the
  ## product and check it for issues once the new version is available.
  ## 
  ## Uploaded attributes first need to be processed before they can be
  ## retrieved. Until then, new products will be unavailable, and retrieval
  ## of previously uploaded products will return the original state of the
  ## product.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name in the format `{target_country}:{content_language}:{product_id}`.
  ## 
  ## `target_country`   - The target country of the product as a CLDR territory
  ##                      code (for example, US).
  ## 
  ## `content_language` - The content language of the product as a two-letter
  ##                      ISO 639-1 language code (for example, en).
  ## 
  ## `product_id`     -   The ID of the product. For more information, see
  ##                      https://support.google.com/manufacturers/answer/6124116#id.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589041 = newJObject()
  var query_589042 = newJObject()
  var body_589043 = newJObject()
  add(query_589042, "upload_protocol", newJString(uploadProtocol))
  add(query_589042, "fields", newJString(fields))
  add(query_589042, "quotaUser", newJString(quotaUser))
  add(path_589041, "name", newJString(name))
  add(query_589042, "alt", newJString(alt))
  add(query_589042, "oauth_token", newJString(oauthToken))
  add(query_589042, "callback", newJString(callback))
  add(query_589042, "access_token", newJString(accessToken))
  add(query_589042, "uploadType", newJString(uploadType))
  add(path_589041, "parent", newJString(parent))
  add(query_589042, "key", newJString(key))
  add(query_589042, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589043 = body
  add(query_589042, "prettyPrint", newJBool(prettyPrint))
  result = call_589040.call(path_589041, query_589042, nil, nil, body_589043)

var manufacturersAccountsProductsUpdate* = Call_ManufacturersAccountsProductsUpdate_589022(
    name: "manufacturersAccountsProductsUpdate", meth: HttpMethod.HttpPut,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsUpdate_589023, base: "/",
    url: url_ManufacturersAccountsProductsUpdate_589024, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsGet_589001 = ref object of OpenApiRestCall_588441
proc url_ManufacturersAccountsProductsGet_589003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManufacturersAccountsProductsGet_589002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the product from a Manufacturer Center account, including product
  ## issues.
  ## 
  ## A recently updated product takes around 15 minutes to process. Changes are
  ## only visible after it has been processed. While some issues may be
  ## available once the product has been processed, other issues may take days
  ## to appear.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name in the format `{target_country}:{content_language}:{product_id}`.
  ## 
  ## `target_country`   - The target country of the product as a CLDR territory
  ##                      code (for example, US).
  ## 
  ## `content_language` - The content language of the product as a two-letter
  ##                      ISO 639-1 language code (for example, en).
  ## 
  ## `product_id`     -   The ID of the product. For more information, see
  ##                      https://support.google.com/manufacturers/answer/6124116#id.
  ##   parent: JString (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589004 = path.getOrDefault("name")
  valid_589004 = validateParameter(valid_589004, JString, required = true,
                                 default = nil)
  if valid_589004 != nil:
    section.add "name", valid_589004
  var valid_589005 = path.getOrDefault("parent")
  valid_589005 = validateParameter(valid_589005, JString, required = true,
                                 default = nil)
  if valid_589005 != nil:
    section.add "parent", valid_589005
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589006 = query.getOrDefault("upload_protocol")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "upload_protocol", valid_589006
  var valid_589007 = query.getOrDefault("fields")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "fields", valid_589007
  var valid_589008 = query.getOrDefault("quotaUser")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "quotaUser", valid_589008
  var valid_589009 = query.getOrDefault("alt")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = newJString("json"))
  if valid_589009 != nil:
    section.add "alt", valid_589009
  var valid_589010 = query.getOrDefault("oauth_token")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "oauth_token", valid_589010
  var valid_589011 = query.getOrDefault("callback")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "callback", valid_589011
  var valid_589012 = query.getOrDefault("access_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "access_token", valid_589012
  var valid_589013 = query.getOrDefault("uploadType")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "uploadType", valid_589013
  var valid_589014 = query.getOrDefault("include")
  valid_589014 = validateParameter(valid_589014, JArray, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "include", valid_589014
  var valid_589015 = query.getOrDefault("key")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "key", valid_589015
  var valid_589016 = query.getOrDefault("$.xgafv")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("1"))
  if valid_589016 != nil:
    section.add "$.xgafv", valid_589016
  var valid_589017 = query.getOrDefault("prettyPrint")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "prettyPrint", valid_589017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589018: Call_ManufacturersAccountsProductsGet_589001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the product from a Manufacturer Center account, including product
  ## issues.
  ## 
  ## A recently updated product takes around 15 minutes to process. Changes are
  ## only visible after it has been processed. While some issues may be
  ## available once the product has been processed, other issues may take days
  ## to appear.
  ## 
  let valid = call_589018.validator(path, query, header, formData, body)
  let scheme = call_589018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589018.url(scheme.get, call_589018.host, call_589018.base,
                         call_589018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589018, url, valid)

proc call*(call_589019: Call_ManufacturersAccountsProductsGet_589001; name: string;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          `include`: JsonNode = nil; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## manufacturersAccountsProductsGet
  ## Gets the product from a Manufacturer Center account, including product
  ## issues.
  ## 
  ## A recently updated product takes around 15 minutes to process. Changes are
  ## only visible after it has been processed. While some issues may be
  ## available once the product has been processed, other issues may take days
  ## to appear.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name in the format `{target_country}:{content_language}:{product_id}`.
  ## 
  ## `target_country`   - The target country of the product as a CLDR territory
  ##                      code (for example, US).
  ## 
  ## `content_language` - The content language of the product as a two-letter
  ##                      ISO 639-1 language code (for example, en).
  ## 
  ## `product_id`     -   The ID of the product. For more information, see
  ##                      https://support.google.com/manufacturers/answer/6124116#id.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589020 = newJObject()
  var query_589021 = newJObject()
  add(query_589021, "upload_protocol", newJString(uploadProtocol))
  add(query_589021, "fields", newJString(fields))
  add(query_589021, "quotaUser", newJString(quotaUser))
  add(path_589020, "name", newJString(name))
  add(query_589021, "alt", newJString(alt))
  add(query_589021, "oauth_token", newJString(oauthToken))
  add(query_589021, "callback", newJString(callback))
  add(query_589021, "access_token", newJString(accessToken))
  add(query_589021, "uploadType", newJString(uploadType))
  add(path_589020, "parent", newJString(parent))
  if `include` != nil:
    query_589021.add "include", `include`
  add(query_589021, "key", newJString(key))
  add(query_589021, "$.xgafv", newJString(Xgafv))
  add(query_589021, "prettyPrint", newJBool(prettyPrint))
  result = call_589019.call(path_589020, query_589021, nil, nil, nil)

var manufacturersAccountsProductsGet* = Call_ManufacturersAccountsProductsGet_589001(
    name: "manufacturersAccountsProductsGet", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsGet_589002, base: "/",
    url: url_ManufacturersAccountsProductsGet_589003, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsDelete_589044 = ref object of OpenApiRestCall_588441
proc url_ManufacturersAccountsProductsDelete_589046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManufacturersAccountsProductsDelete_589045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the product from a Manufacturer Center account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name in the format `{target_country}:{content_language}:{product_id}`.
  ## 
  ## `target_country`   - The target country of the product as a CLDR territory
  ##                      code (for example, US).
  ## 
  ## `content_language` - The content language of the product as a two-letter
  ##                      ISO 639-1 language code (for example, en).
  ## 
  ## `product_id`     -   The ID of the product. For more information, see
  ##                      https://support.google.com/manufacturers/answer/6124116#id.
  ##   parent: JString (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589047 = path.getOrDefault("name")
  valid_589047 = validateParameter(valid_589047, JString, required = true,
                                 default = nil)
  if valid_589047 != nil:
    section.add "name", valid_589047
  var valid_589048 = path.getOrDefault("parent")
  valid_589048 = validateParameter(valid_589048, JString, required = true,
                                 default = nil)
  if valid_589048 != nil:
    section.add "parent", valid_589048
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589049 = query.getOrDefault("upload_protocol")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "upload_protocol", valid_589049
  var valid_589050 = query.getOrDefault("fields")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "fields", valid_589050
  var valid_589051 = query.getOrDefault("quotaUser")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "quotaUser", valid_589051
  var valid_589052 = query.getOrDefault("alt")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("json"))
  if valid_589052 != nil:
    section.add "alt", valid_589052
  var valid_589053 = query.getOrDefault("oauth_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "oauth_token", valid_589053
  var valid_589054 = query.getOrDefault("callback")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "callback", valid_589054
  var valid_589055 = query.getOrDefault("access_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "access_token", valid_589055
  var valid_589056 = query.getOrDefault("uploadType")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "uploadType", valid_589056
  var valid_589057 = query.getOrDefault("key")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "key", valid_589057
  var valid_589058 = query.getOrDefault("$.xgafv")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("1"))
  if valid_589058 != nil:
    section.add "$.xgafv", valid_589058
  var valid_589059 = query.getOrDefault("prettyPrint")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "prettyPrint", valid_589059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589060: Call_ManufacturersAccountsProductsDelete_589044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the product from a Manufacturer Center account.
  ## 
  let valid = call_589060.validator(path, query, header, formData, body)
  let scheme = call_589060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589060.url(scheme.get, call_589060.host, call_589060.base,
                         call_589060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589060, url, valid)

proc call*(call_589061: Call_ManufacturersAccountsProductsDelete_589044;
          name: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## manufacturersAccountsProductsDelete
  ## Deletes the product from a Manufacturer Center account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name in the format `{target_country}:{content_language}:{product_id}`.
  ## 
  ## `target_country`   - The target country of the product as a CLDR territory
  ##                      code (for example, US).
  ## 
  ## `content_language` - The content language of the product as a two-letter
  ##                      ISO 639-1 language code (for example, en).
  ## 
  ## `product_id`     -   The ID of the product. For more information, see
  ##                      https://support.google.com/manufacturers/answer/6124116#id.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589062 = newJObject()
  var query_589063 = newJObject()
  add(query_589063, "upload_protocol", newJString(uploadProtocol))
  add(query_589063, "fields", newJString(fields))
  add(query_589063, "quotaUser", newJString(quotaUser))
  add(path_589062, "name", newJString(name))
  add(query_589063, "alt", newJString(alt))
  add(query_589063, "oauth_token", newJString(oauthToken))
  add(query_589063, "callback", newJString(callback))
  add(query_589063, "access_token", newJString(accessToken))
  add(query_589063, "uploadType", newJString(uploadType))
  add(path_589062, "parent", newJString(parent))
  add(query_589063, "key", newJString(key))
  add(query_589063, "$.xgafv", newJString(Xgafv))
  add(query_589063, "prettyPrint", newJBool(prettyPrint))
  result = call_589061.call(path_589062, query_589063, nil, nil, nil)

var manufacturersAccountsProductsDelete* = Call_ManufacturersAccountsProductsDelete_589044(
    name: "manufacturersAccountsProductsDelete", meth: HttpMethod.HttpDelete,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsDelete_589045, base: "/",
    url: url_ManufacturersAccountsProductsDelete_589046, schemes: {Scheme.Https})
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
