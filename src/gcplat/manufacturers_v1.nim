
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "manufacturers"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManufacturersAccountsProductsList_578610 = ref object of OpenApiRestCall_578339
proc url_ManufacturersAccountsProductsList_578612(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsList_578611(path: JsonNode;
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
  var valid_578738 = path.getOrDefault("parent")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "parent", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of product statuses to return in the response, used for
  ## paging.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("pageSize")
  valid_578756 = validateParameter(valid_578756, JInt, required = false, default = nil)
  if valid_578756 != nil:
    section.add "pageSize", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("uploadType")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "uploadType", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  var valid_578760 = query.getOrDefault("pageToken")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "pageToken", valid_578760
  var valid_578761 = query.getOrDefault("include")
  valid_578761 = validateParameter(valid_578761, JArray, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "include", valid_578761
  var valid_578762 = query.getOrDefault("callback")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "callback", valid_578762
  var valid_578763 = query.getOrDefault("fields")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "fields", valid_578763
  var valid_578764 = query.getOrDefault("access_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "access_token", valid_578764
  var valid_578765 = query.getOrDefault("upload_protocol")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "upload_protocol", valid_578765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578788: Call_ManufacturersAccountsProductsList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the products in a Manufacturer Center account.
  ## 
  let valid = call_578788.validator(path, query, header, formData, body)
  let scheme = call_578788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578788.url(scheme.get, call_578788.host, call_578788.base,
                         call_578788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578788, url, valid)

proc call*(call_578859: Call_ManufacturersAccountsProductsList_578610;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; `include`: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## manufacturersAccountsProductsList
  ## Lists all the products in a Manufacturer Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of product statuses to return in the response, used for
  ## paging.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578860 = newJObject()
  var query_578862 = newJObject()
  add(query_578862, "key", newJString(key))
  add(query_578862, "prettyPrint", newJBool(prettyPrint))
  add(query_578862, "oauth_token", newJString(oauthToken))
  add(query_578862, "$.xgafv", newJString(Xgafv))
  add(query_578862, "pageSize", newJInt(pageSize))
  add(query_578862, "alt", newJString(alt))
  add(query_578862, "uploadType", newJString(uploadType))
  add(query_578862, "quotaUser", newJString(quotaUser))
  add(query_578862, "pageToken", newJString(pageToken))
  if `include` != nil:
    query_578862.add "include", `include`
  add(query_578862, "callback", newJString(callback))
  add(path_578860, "parent", newJString(parent))
  add(query_578862, "fields", newJString(fields))
  add(query_578862, "access_token", newJString(accessToken))
  add(query_578862, "upload_protocol", newJString(uploadProtocol))
  result = call_578859.call(path_578860, query_578862, nil, nil, nil)

var manufacturersAccountsProductsList* = Call_ManufacturersAccountsProductsList_578610(
    name: "manufacturersAccountsProductsList", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_ManufacturersAccountsProductsList_578611, base: "/",
    url: url_ManufacturersAccountsProductsList_578612, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsUpdate_578922 = ref object of OpenApiRestCall_578339
proc url_ManufacturersAccountsProductsUpdate_578924(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsUpdate_578923(path: JsonNode;
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
  var valid_578925 = path.getOrDefault("name")
  valid_578925 = validateParameter(valid_578925, JString, required = true,
                                 default = nil)
  if valid_578925 != nil:
    section.add "name", valid_578925
  var valid_578926 = path.getOrDefault("parent")
  valid_578926 = validateParameter(valid_578926, JString, required = true,
                                 default = nil)
  if valid_578926 != nil:
    section.add "parent", valid_578926
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("$.xgafv")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("1"))
  if valid_578930 != nil:
    section.add "$.xgafv", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("uploadType")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "uploadType", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("callback")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "callback", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("access_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "access_token", valid_578936
  var valid_578937 = query.getOrDefault("upload_protocol")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "upload_protocol", valid_578937
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

proc call*(call_578939: Call_ManufacturersAccountsProductsUpdate_578922;
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
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_ManufacturersAccountsProductsUpdate_578922;
          name: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578941 = newJObject()
  var query_578942 = newJObject()
  var body_578943 = newJObject()
  add(query_578942, "key", newJString(key))
  add(query_578942, "prettyPrint", newJBool(prettyPrint))
  add(query_578942, "oauth_token", newJString(oauthToken))
  add(query_578942, "$.xgafv", newJString(Xgafv))
  add(query_578942, "alt", newJString(alt))
  add(query_578942, "uploadType", newJString(uploadType))
  add(query_578942, "quotaUser", newJString(quotaUser))
  add(path_578941, "name", newJString(name))
  if body != nil:
    body_578943 = body
  add(query_578942, "callback", newJString(callback))
  add(path_578941, "parent", newJString(parent))
  add(query_578942, "fields", newJString(fields))
  add(query_578942, "access_token", newJString(accessToken))
  add(query_578942, "upload_protocol", newJString(uploadProtocol))
  result = call_578940.call(path_578941, query_578942, nil, nil, body_578943)

var manufacturersAccountsProductsUpdate* = Call_ManufacturersAccountsProductsUpdate_578922(
    name: "manufacturersAccountsProductsUpdate", meth: HttpMethod.HttpPut,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsUpdate_578923, base: "/",
    url: url_ManufacturersAccountsProductsUpdate_578924, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsGet_578901 = ref object of OpenApiRestCall_578339
proc url_ManufacturersAccountsProductsGet_578903(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsGet_578902(path: JsonNode;
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
  var valid_578904 = path.getOrDefault("name")
  valid_578904 = validateParameter(valid_578904, JString, required = true,
                                 default = nil)
  if valid_578904 != nil:
    section.add "name", valid_578904
  var valid_578905 = path.getOrDefault("parent")
  valid_578905 = validateParameter(valid_578905, JString, required = true,
                                 default = nil)
  if valid_578905 != nil:
    section.add "parent", valid_578905
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578906 = query.getOrDefault("key")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "key", valid_578906
  var valid_578907 = query.getOrDefault("prettyPrint")
  valid_578907 = validateParameter(valid_578907, JBool, required = false,
                                 default = newJBool(true))
  if valid_578907 != nil:
    section.add "prettyPrint", valid_578907
  var valid_578908 = query.getOrDefault("oauth_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "oauth_token", valid_578908
  var valid_578909 = query.getOrDefault("$.xgafv")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("1"))
  if valid_578909 != nil:
    section.add "$.xgafv", valid_578909
  var valid_578910 = query.getOrDefault("alt")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("json"))
  if valid_578910 != nil:
    section.add "alt", valid_578910
  var valid_578911 = query.getOrDefault("uploadType")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "uploadType", valid_578911
  var valid_578912 = query.getOrDefault("quotaUser")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "quotaUser", valid_578912
  var valid_578913 = query.getOrDefault("include")
  valid_578913 = validateParameter(valid_578913, JArray, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "include", valid_578913
  var valid_578914 = query.getOrDefault("callback")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "callback", valid_578914
  var valid_578915 = query.getOrDefault("fields")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "fields", valid_578915
  var valid_578916 = query.getOrDefault("access_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "access_token", valid_578916
  var valid_578917 = query.getOrDefault("upload_protocol")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "upload_protocol", valid_578917
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578918: Call_ManufacturersAccountsProductsGet_578901;
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
  let valid = call_578918.validator(path, query, header, formData, body)
  let scheme = call_578918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578918.url(scheme.get, call_578918.host, call_578918.base,
                         call_578918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578918, url, valid)

proc call*(call_578919: Call_ManufacturersAccountsProductsGet_578901; name: string;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; `include`: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## manufacturersAccountsProductsGet
  ## Gets the product from a Manufacturer Center account, including product
  ## issues.
  ## 
  ## A recently updated product takes around 15 minutes to process. Changes are
  ## only visible after it has been processed. While some issues may be
  ## available once the product has been processed, other issues may take days
  ## to appear.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   include: JArray
  ##          : The information to be included in the response. Only sections listed here
  ## will be returned.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578920 = newJObject()
  var query_578921 = newJObject()
  add(query_578921, "key", newJString(key))
  add(query_578921, "prettyPrint", newJBool(prettyPrint))
  add(query_578921, "oauth_token", newJString(oauthToken))
  add(query_578921, "$.xgafv", newJString(Xgafv))
  add(query_578921, "alt", newJString(alt))
  add(query_578921, "uploadType", newJString(uploadType))
  add(query_578921, "quotaUser", newJString(quotaUser))
  add(path_578920, "name", newJString(name))
  if `include` != nil:
    query_578921.add "include", `include`
  add(query_578921, "callback", newJString(callback))
  add(path_578920, "parent", newJString(parent))
  add(query_578921, "fields", newJString(fields))
  add(query_578921, "access_token", newJString(accessToken))
  add(query_578921, "upload_protocol", newJString(uploadProtocol))
  result = call_578919.call(path_578920, query_578921, nil, nil, nil)

var manufacturersAccountsProductsGet* = Call_ManufacturersAccountsProductsGet_578901(
    name: "manufacturersAccountsProductsGet", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsGet_578902, base: "/",
    url: url_ManufacturersAccountsProductsGet_578903, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsDelete_578944 = ref object of OpenApiRestCall_578339
proc url_ManufacturersAccountsProductsDelete_578946(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsDelete_578945(path: JsonNode;
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
  var valid_578947 = path.getOrDefault("name")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "name", valid_578947
  var valid_578948 = path.getOrDefault("parent")
  valid_578948 = validateParameter(valid_578948, JString, required = true,
                                 default = nil)
  if valid_578948 != nil:
    section.add "parent", valid_578948
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578949 = query.getOrDefault("key")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "key", valid_578949
  var valid_578950 = query.getOrDefault("prettyPrint")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "prettyPrint", valid_578950
  var valid_578951 = query.getOrDefault("oauth_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "oauth_token", valid_578951
  var valid_578952 = query.getOrDefault("$.xgafv")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("1"))
  if valid_578952 != nil:
    section.add "$.xgafv", valid_578952
  var valid_578953 = query.getOrDefault("alt")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = newJString("json"))
  if valid_578953 != nil:
    section.add "alt", valid_578953
  var valid_578954 = query.getOrDefault("uploadType")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "uploadType", valid_578954
  var valid_578955 = query.getOrDefault("quotaUser")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "quotaUser", valid_578955
  var valid_578956 = query.getOrDefault("callback")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "callback", valid_578956
  var valid_578957 = query.getOrDefault("fields")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "fields", valid_578957
  var valid_578958 = query.getOrDefault("access_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "access_token", valid_578958
  var valid_578959 = query.getOrDefault("upload_protocol")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "upload_protocol", valid_578959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578960: Call_ManufacturersAccountsProductsDelete_578944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the product from a Manufacturer Center account.
  ## 
  let valid = call_578960.validator(path, query, header, formData, body)
  let scheme = call_578960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578960.url(scheme.get, call_578960.host, call_578960.base,
                         call_578960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578960, url, valid)

proc call*(call_578961: Call_ManufacturersAccountsProductsDelete_578944;
          name: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## manufacturersAccountsProductsDelete
  ## Deletes the product from a Manufacturer Center account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent ID in the format `accounts/{account_id}`.
  ## 
  ## `account_id` - The ID of the Manufacturer Center account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578962 = newJObject()
  var query_578963 = newJObject()
  add(query_578963, "key", newJString(key))
  add(query_578963, "prettyPrint", newJBool(prettyPrint))
  add(query_578963, "oauth_token", newJString(oauthToken))
  add(query_578963, "$.xgafv", newJString(Xgafv))
  add(query_578963, "alt", newJString(alt))
  add(query_578963, "uploadType", newJString(uploadType))
  add(query_578963, "quotaUser", newJString(quotaUser))
  add(path_578962, "name", newJString(name))
  add(query_578963, "callback", newJString(callback))
  add(path_578962, "parent", newJString(parent))
  add(query_578963, "fields", newJString(fields))
  add(query_578963, "access_token", newJString(accessToken))
  add(query_578963, "upload_protocol", newJString(uploadProtocol))
  result = call_578961.call(path_578962, query_578963, nil, nil, nil)

var manufacturersAccountsProductsDelete* = Call_ManufacturersAccountsProductsDelete_578944(
    name: "manufacturersAccountsProductsDelete", meth: HttpMethod.HttpDelete,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsDelete_578945, base: "/",
    url: url_ManufacturersAccountsProductsDelete_578946, schemes: {Scheme.Https})
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
