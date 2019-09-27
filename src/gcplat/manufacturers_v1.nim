
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "manufacturers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManufacturersAccountsProductsList_593677 = ref object of OpenApiRestCall_593408
proc url_ManufacturersAccountsProductsList_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ManufacturersAccountsProductsList_593678(path: JsonNode;
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
  var valid_593805 = path.getOrDefault("parent")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "parent", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("pageToken")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "pageToken", valid_593808
  var valid_593809 = query.getOrDefault("quotaUser")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "quotaUser", valid_593809
  var valid_593823 = query.getOrDefault("alt")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = newJString("json"))
  if valid_593823 != nil:
    section.add "alt", valid_593823
  var valid_593824 = query.getOrDefault("oauth_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "oauth_token", valid_593824
  var valid_593825 = query.getOrDefault("callback")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "callback", valid_593825
  var valid_593826 = query.getOrDefault("access_token")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "access_token", valid_593826
  var valid_593827 = query.getOrDefault("uploadType")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "uploadType", valid_593827
  var valid_593828 = query.getOrDefault("include")
  valid_593828 = validateParameter(valid_593828, JArray, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "include", valid_593828
  var valid_593829 = query.getOrDefault("key")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = nil)
  if valid_593829 != nil:
    section.add "key", valid_593829
  var valid_593830 = query.getOrDefault("$.xgafv")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = newJString("1"))
  if valid_593830 != nil:
    section.add "$.xgafv", valid_593830
  var valid_593831 = query.getOrDefault("pageSize")
  valid_593831 = validateParameter(valid_593831, JInt, required = false, default = nil)
  if valid_593831 != nil:
    section.add "pageSize", valid_593831
  var valid_593832 = query.getOrDefault("prettyPrint")
  valid_593832 = validateParameter(valid_593832, JBool, required = false,
                                 default = newJBool(true))
  if valid_593832 != nil:
    section.add "prettyPrint", valid_593832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593855: Call_ManufacturersAccountsProductsList_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the products in a Manufacturer Center account.
  ## 
  let valid = call_593855.validator(path, query, header, formData, body)
  let scheme = call_593855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593855.url(scheme.get, call_593855.host, call_593855.base,
                         call_593855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593855, url, valid)

proc call*(call_593926: Call_ManufacturersAccountsProductsList_593677;
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
  var path_593927 = newJObject()
  var query_593929 = newJObject()
  add(query_593929, "upload_protocol", newJString(uploadProtocol))
  add(query_593929, "fields", newJString(fields))
  add(query_593929, "pageToken", newJString(pageToken))
  add(query_593929, "quotaUser", newJString(quotaUser))
  add(query_593929, "alt", newJString(alt))
  add(query_593929, "oauth_token", newJString(oauthToken))
  add(query_593929, "callback", newJString(callback))
  add(query_593929, "access_token", newJString(accessToken))
  add(query_593929, "uploadType", newJString(uploadType))
  add(path_593927, "parent", newJString(parent))
  if `include` != nil:
    query_593929.add "include", `include`
  add(query_593929, "key", newJString(key))
  add(query_593929, "$.xgafv", newJString(Xgafv))
  add(query_593929, "pageSize", newJInt(pageSize))
  add(query_593929, "prettyPrint", newJBool(prettyPrint))
  result = call_593926.call(path_593927, query_593929, nil, nil, nil)

var manufacturersAccountsProductsList* = Call_ManufacturersAccountsProductsList_593677(
    name: "manufacturersAccountsProductsList", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_ManufacturersAccountsProductsList_593678, base: "/",
    url: url_ManufacturersAccountsProductsList_593679, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsUpdate_593989 = ref object of OpenApiRestCall_593408
proc url_ManufacturersAccountsProductsUpdate_593991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ManufacturersAccountsProductsUpdate_593990(path: JsonNode;
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
  var valid_593992 = path.getOrDefault("name")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "name", valid_593992
  var valid_593993 = path.getOrDefault("parent")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "parent", valid_593993
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
  var valid_593994 = query.getOrDefault("upload_protocol")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "upload_protocol", valid_593994
  var valid_593995 = query.getOrDefault("fields")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "fields", valid_593995
  var valid_593996 = query.getOrDefault("quotaUser")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "quotaUser", valid_593996
  var valid_593997 = query.getOrDefault("alt")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("json"))
  if valid_593997 != nil:
    section.add "alt", valid_593997
  var valid_593998 = query.getOrDefault("oauth_token")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "oauth_token", valid_593998
  var valid_593999 = query.getOrDefault("callback")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "callback", valid_593999
  var valid_594000 = query.getOrDefault("access_token")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "access_token", valid_594000
  var valid_594001 = query.getOrDefault("uploadType")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "uploadType", valid_594001
  var valid_594002 = query.getOrDefault("key")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "key", valid_594002
  var valid_594003 = query.getOrDefault("$.xgafv")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = newJString("1"))
  if valid_594003 != nil:
    section.add "$.xgafv", valid_594003
  var valid_594004 = query.getOrDefault("prettyPrint")
  valid_594004 = validateParameter(valid_594004, JBool, required = false,
                                 default = newJBool(true))
  if valid_594004 != nil:
    section.add "prettyPrint", valid_594004
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

proc call*(call_594006: Call_ManufacturersAccountsProductsUpdate_593989;
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
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_ManufacturersAccountsProductsUpdate_593989;
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
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  var body_594010 = newJObject()
  add(query_594009, "upload_protocol", newJString(uploadProtocol))
  add(query_594009, "fields", newJString(fields))
  add(query_594009, "quotaUser", newJString(quotaUser))
  add(path_594008, "name", newJString(name))
  add(query_594009, "alt", newJString(alt))
  add(query_594009, "oauth_token", newJString(oauthToken))
  add(query_594009, "callback", newJString(callback))
  add(query_594009, "access_token", newJString(accessToken))
  add(query_594009, "uploadType", newJString(uploadType))
  add(path_594008, "parent", newJString(parent))
  add(query_594009, "key", newJString(key))
  add(query_594009, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594010 = body
  add(query_594009, "prettyPrint", newJBool(prettyPrint))
  result = call_594007.call(path_594008, query_594009, nil, nil, body_594010)

var manufacturersAccountsProductsUpdate* = Call_ManufacturersAccountsProductsUpdate_593989(
    name: "manufacturersAccountsProductsUpdate", meth: HttpMethod.HttpPut,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsUpdate_593990, base: "/",
    url: url_ManufacturersAccountsProductsUpdate_593991, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsGet_593968 = ref object of OpenApiRestCall_593408
proc url_ManufacturersAccountsProductsGet_593970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ManufacturersAccountsProductsGet_593969(path: JsonNode;
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
  var valid_593971 = path.getOrDefault("name")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "name", valid_593971
  var valid_593972 = path.getOrDefault("parent")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "parent", valid_593972
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
  var valid_593973 = query.getOrDefault("upload_protocol")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "upload_protocol", valid_593973
  var valid_593974 = query.getOrDefault("fields")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "fields", valid_593974
  var valid_593975 = query.getOrDefault("quotaUser")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "quotaUser", valid_593975
  var valid_593976 = query.getOrDefault("alt")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = newJString("json"))
  if valid_593976 != nil:
    section.add "alt", valid_593976
  var valid_593977 = query.getOrDefault("oauth_token")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "oauth_token", valid_593977
  var valid_593978 = query.getOrDefault("callback")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "callback", valid_593978
  var valid_593979 = query.getOrDefault("access_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "access_token", valid_593979
  var valid_593980 = query.getOrDefault("uploadType")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "uploadType", valid_593980
  var valid_593981 = query.getOrDefault("include")
  valid_593981 = validateParameter(valid_593981, JArray, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "include", valid_593981
  var valid_593982 = query.getOrDefault("key")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "key", valid_593982
  var valid_593983 = query.getOrDefault("$.xgafv")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("1"))
  if valid_593983 != nil:
    section.add "$.xgafv", valid_593983
  var valid_593984 = query.getOrDefault("prettyPrint")
  valid_593984 = validateParameter(valid_593984, JBool, required = false,
                                 default = newJBool(true))
  if valid_593984 != nil:
    section.add "prettyPrint", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_ManufacturersAccountsProductsGet_593968;
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
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_ManufacturersAccountsProductsGet_593968; name: string;
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
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(query_593988, "upload_protocol", newJString(uploadProtocol))
  add(query_593988, "fields", newJString(fields))
  add(query_593988, "quotaUser", newJString(quotaUser))
  add(path_593987, "name", newJString(name))
  add(query_593988, "alt", newJString(alt))
  add(query_593988, "oauth_token", newJString(oauthToken))
  add(query_593988, "callback", newJString(callback))
  add(query_593988, "access_token", newJString(accessToken))
  add(query_593988, "uploadType", newJString(uploadType))
  add(path_593987, "parent", newJString(parent))
  if `include` != nil:
    query_593988.add "include", `include`
  add(query_593988, "key", newJString(key))
  add(query_593988, "$.xgafv", newJString(Xgafv))
  add(query_593988, "prettyPrint", newJBool(prettyPrint))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var manufacturersAccountsProductsGet* = Call_ManufacturersAccountsProductsGet_593968(
    name: "manufacturersAccountsProductsGet", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsGet_593969, base: "/",
    url: url_ManufacturersAccountsProductsGet_593970, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsDelete_594011 = ref object of OpenApiRestCall_593408
proc url_ManufacturersAccountsProductsDelete_594013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ManufacturersAccountsProductsDelete_594012(path: JsonNode;
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
  var valid_594014 = path.getOrDefault("name")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "name", valid_594014
  var valid_594015 = path.getOrDefault("parent")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "parent", valid_594015
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
  var valid_594016 = query.getOrDefault("upload_protocol")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "upload_protocol", valid_594016
  var valid_594017 = query.getOrDefault("fields")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "fields", valid_594017
  var valid_594018 = query.getOrDefault("quotaUser")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "quotaUser", valid_594018
  var valid_594019 = query.getOrDefault("alt")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = newJString("json"))
  if valid_594019 != nil:
    section.add "alt", valid_594019
  var valid_594020 = query.getOrDefault("oauth_token")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "oauth_token", valid_594020
  var valid_594021 = query.getOrDefault("callback")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "callback", valid_594021
  var valid_594022 = query.getOrDefault("access_token")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "access_token", valid_594022
  var valid_594023 = query.getOrDefault("uploadType")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "uploadType", valid_594023
  var valid_594024 = query.getOrDefault("key")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "key", valid_594024
  var valid_594025 = query.getOrDefault("$.xgafv")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = newJString("1"))
  if valid_594025 != nil:
    section.add "$.xgafv", valid_594025
  var valid_594026 = query.getOrDefault("prettyPrint")
  valid_594026 = validateParameter(valid_594026, JBool, required = false,
                                 default = newJBool(true))
  if valid_594026 != nil:
    section.add "prettyPrint", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_ManufacturersAccountsProductsDelete_594011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the product from a Manufacturer Center account.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_ManufacturersAccountsProductsDelete_594011;
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
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(query_594030, "upload_protocol", newJString(uploadProtocol))
  add(query_594030, "fields", newJString(fields))
  add(query_594030, "quotaUser", newJString(quotaUser))
  add(path_594029, "name", newJString(name))
  add(query_594030, "alt", newJString(alt))
  add(query_594030, "oauth_token", newJString(oauthToken))
  add(query_594030, "callback", newJString(callback))
  add(query_594030, "access_token", newJString(accessToken))
  add(query_594030, "uploadType", newJString(uploadType))
  add(path_594029, "parent", newJString(parent))
  add(query_594030, "key", newJString(key))
  add(query_594030, "$.xgafv", newJString(Xgafv))
  add(query_594030, "prettyPrint", newJBool(prettyPrint))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var manufacturersAccountsProductsDelete* = Call_ManufacturersAccountsProductsDelete_594011(
    name: "manufacturersAccountsProductsDelete", meth: HttpMethod.HttpDelete,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsDelete_594012, base: "/",
    url: url_ManufacturersAccountsProductsDelete_594013, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
