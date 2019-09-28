
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
  gcpServiceName = "manufacturers"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManufacturersAccountsProductsList_579677 = ref object of OpenApiRestCall_579408
proc url_ManufacturersAccountsProductsList_579679(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsList_579678(path: JsonNode;
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
  var valid_579805 = path.getOrDefault("parent")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "parent", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("pageToken")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "pageToken", valid_579808
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
  var valid_579825 = query.getOrDefault("callback")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "callback", valid_579825
  var valid_579826 = query.getOrDefault("access_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "access_token", valid_579826
  var valid_579827 = query.getOrDefault("uploadType")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "uploadType", valid_579827
  var valid_579828 = query.getOrDefault("include")
  valid_579828 = validateParameter(valid_579828, JArray, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "include", valid_579828
  var valid_579829 = query.getOrDefault("key")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "key", valid_579829
  var valid_579830 = query.getOrDefault("$.xgafv")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = newJString("1"))
  if valid_579830 != nil:
    section.add "$.xgafv", valid_579830
  var valid_579831 = query.getOrDefault("pageSize")
  valid_579831 = validateParameter(valid_579831, JInt, required = false, default = nil)
  if valid_579831 != nil:
    section.add "pageSize", valid_579831
  var valid_579832 = query.getOrDefault("prettyPrint")
  valid_579832 = validateParameter(valid_579832, JBool, required = false,
                                 default = newJBool(true))
  if valid_579832 != nil:
    section.add "prettyPrint", valid_579832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579855: Call_ManufacturersAccountsProductsList_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the products in a Manufacturer Center account.
  ## 
  let valid = call_579855.validator(path, query, header, formData, body)
  let scheme = call_579855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579855.url(scheme.get, call_579855.host, call_579855.base,
                         call_579855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579855, url, valid)

proc call*(call_579926: Call_ManufacturersAccountsProductsList_579677;
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
  var path_579927 = newJObject()
  var query_579929 = newJObject()
  add(query_579929, "upload_protocol", newJString(uploadProtocol))
  add(query_579929, "fields", newJString(fields))
  add(query_579929, "pageToken", newJString(pageToken))
  add(query_579929, "quotaUser", newJString(quotaUser))
  add(query_579929, "alt", newJString(alt))
  add(query_579929, "oauth_token", newJString(oauthToken))
  add(query_579929, "callback", newJString(callback))
  add(query_579929, "access_token", newJString(accessToken))
  add(query_579929, "uploadType", newJString(uploadType))
  add(path_579927, "parent", newJString(parent))
  if `include` != nil:
    query_579929.add "include", `include`
  add(query_579929, "key", newJString(key))
  add(query_579929, "$.xgafv", newJString(Xgafv))
  add(query_579929, "pageSize", newJInt(pageSize))
  add(query_579929, "prettyPrint", newJBool(prettyPrint))
  result = call_579926.call(path_579927, query_579929, nil, nil, nil)

var manufacturersAccountsProductsList* = Call_ManufacturersAccountsProductsList_579677(
    name: "manufacturersAccountsProductsList", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_ManufacturersAccountsProductsList_579678, base: "/",
    url: url_ManufacturersAccountsProductsList_579679, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsUpdate_579989 = ref object of OpenApiRestCall_579408
proc url_ManufacturersAccountsProductsUpdate_579991(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsUpdate_579990(path: JsonNode;
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
  var valid_579992 = path.getOrDefault("name")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "name", valid_579992
  var valid_579993 = path.getOrDefault("parent")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "parent", valid_579993
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
  var valid_579994 = query.getOrDefault("upload_protocol")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "upload_protocol", valid_579994
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("callback")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "callback", valid_579999
  var valid_580000 = query.getOrDefault("access_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "access_token", valid_580000
  var valid_580001 = query.getOrDefault("uploadType")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "uploadType", valid_580001
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("$.xgafv")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("1"))
  if valid_580003 != nil:
    section.add "$.xgafv", valid_580003
  var valid_580004 = query.getOrDefault("prettyPrint")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(true))
  if valid_580004 != nil:
    section.add "prettyPrint", valid_580004
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

proc call*(call_580006: Call_ManufacturersAccountsProductsUpdate_579989;
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
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_ManufacturersAccountsProductsUpdate_579989;
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
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  var body_580010 = newJObject()
  add(query_580009, "upload_protocol", newJString(uploadProtocol))
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(path_580008, "name", newJString(name))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "callback", newJString(callback))
  add(query_580009, "access_token", newJString(accessToken))
  add(query_580009, "uploadType", newJString(uploadType))
  add(path_580008, "parent", newJString(parent))
  add(query_580009, "key", newJString(key))
  add(query_580009, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580010 = body
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, body_580010)

var manufacturersAccountsProductsUpdate* = Call_ManufacturersAccountsProductsUpdate_579989(
    name: "manufacturersAccountsProductsUpdate", meth: HttpMethod.HttpPut,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsUpdate_579990, base: "/",
    url: url_ManufacturersAccountsProductsUpdate_579991, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsGet_579968 = ref object of OpenApiRestCall_579408
proc url_ManufacturersAccountsProductsGet_579970(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsGet_579969(path: JsonNode;
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
  var valid_579971 = path.getOrDefault("name")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "name", valid_579971
  var valid_579972 = path.getOrDefault("parent")
  valid_579972 = validateParameter(valid_579972, JString, required = true,
                                 default = nil)
  if valid_579972 != nil:
    section.add "parent", valid_579972
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
  var valid_579973 = query.getOrDefault("upload_protocol")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "upload_protocol", valid_579973
  var valid_579974 = query.getOrDefault("fields")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "fields", valid_579974
  var valid_579975 = query.getOrDefault("quotaUser")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "quotaUser", valid_579975
  var valid_579976 = query.getOrDefault("alt")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("json"))
  if valid_579976 != nil:
    section.add "alt", valid_579976
  var valid_579977 = query.getOrDefault("oauth_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "oauth_token", valid_579977
  var valid_579978 = query.getOrDefault("callback")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "callback", valid_579978
  var valid_579979 = query.getOrDefault("access_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "access_token", valid_579979
  var valid_579980 = query.getOrDefault("uploadType")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "uploadType", valid_579980
  var valid_579981 = query.getOrDefault("include")
  valid_579981 = validateParameter(valid_579981, JArray, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "include", valid_579981
  var valid_579982 = query.getOrDefault("key")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "key", valid_579982
  var valid_579983 = query.getOrDefault("$.xgafv")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("1"))
  if valid_579983 != nil:
    section.add "$.xgafv", valid_579983
  var valid_579984 = query.getOrDefault("prettyPrint")
  valid_579984 = validateParameter(valid_579984, JBool, required = false,
                                 default = newJBool(true))
  if valid_579984 != nil:
    section.add "prettyPrint", valid_579984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579985: Call_ManufacturersAccountsProductsGet_579968;
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
  let valid = call_579985.validator(path, query, header, formData, body)
  let scheme = call_579985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579985.url(scheme.get, call_579985.host, call_579985.base,
                         call_579985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579985, url, valid)

proc call*(call_579986: Call_ManufacturersAccountsProductsGet_579968; name: string;
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
  var path_579987 = newJObject()
  var query_579988 = newJObject()
  add(query_579988, "upload_protocol", newJString(uploadProtocol))
  add(query_579988, "fields", newJString(fields))
  add(query_579988, "quotaUser", newJString(quotaUser))
  add(path_579987, "name", newJString(name))
  add(query_579988, "alt", newJString(alt))
  add(query_579988, "oauth_token", newJString(oauthToken))
  add(query_579988, "callback", newJString(callback))
  add(query_579988, "access_token", newJString(accessToken))
  add(query_579988, "uploadType", newJString(uploadType))
  add(path_579987, "parent", newJString(parent))
  if `include` != nil:
    query_579988.add "include", `include`
  add(query_579988, "key", newJString(key))
  add(query_579988, "$.xgafv", newJString(Xgafv))
  add(query_579988, "prettyPrint", newJBool(prettyPrint))
  result = call_579986.call(path_579987, query_579988, nil, nil, nil)

var manufacturersAccountsProductsGet* = Call_ManufacturersAccountsProductsGet_579968(
    name: "manufacturersAccountsProductsGet", meth: HttpMethod.HttpGet,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsGet_579969, base: "/",
    url: url_ManufacturersAccountsProductsGet_579970, schemes: {Scheme.Https})
type
  Call_ManufacturersAccountsProductsDelete_580011 = ref object of OpenApiRestCall_579408
proc url_ManufacturersAccountsProductsDelete_580013(protocol: Scheme; host: string;
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

proc validate_ManufacturersAccountsProductsDelete_580012(path: JsonNode;
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
  var valid_580014 = path.getOrDefault("name")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "name", valid_580014
  var valid_580015 = path.getOrDefault("parent")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "parent", valid_580015
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
  var valid_580016 = query.getOrDefault("upload_protocol")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "upload_protocol", valid_580016
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("callback")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "callback", valid_580021
  var valid_580022 = query.getOrDefault("access_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "access_token", valid_580022
  var valid_580023 = query.getOrDefault("uploadType")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "uploadType", valid_580023
  var valid_580024 = query.getOrDefault("key")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "key", valid_580024
  var valid_580025 = query.getOrDefault("$.xgafv")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("1"))
  if valid_580025 != nil:
    section.add "$.xgafv", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580027: Call_ManufacturersAccountsProductsDelete_580011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the product from a Manufacturer Center account.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_ManufacturersAccountsProductsDelete_580011;
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
  var path_580029 = newJObject()
  var query_580030 = newJObject()
  add(query_580030, "upload_protocol", newJString(uploadProtocol))
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(path_580029, "name", newJString(name))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(query_580030, "callback", newJString(callback))
  add(query_580030, "access_token", newJString(accessToken))
  add(query_580030, "uploadType", newJString(uploadType))
  add(path_580029, "parent", newJString(parent))
  add(query_580030, "key", newJString(key))
  add(query_580030, "$.xgafv", newJString(Xgafv))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  result = call_580028.call(path_580029, query_580030, nil, nil, nil)

var manufacturersAccountsProductsDelete* = Call_ManufacturersAccountsProductsDelete_580011(
    name: "manufacturersAccountsProductsDelete", meth: HttpMethod.HttpDelete,
    host: "manufacturers.googleapis.com", route: "/v1/{parent}/products/{name}",
    validator: validate_ManufacturersAccountsProductsDelete_580012, base: "/",
    url: url_ManufacturersAccountsProductsDelete_580013, schemes: {Scheme.Https})
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
