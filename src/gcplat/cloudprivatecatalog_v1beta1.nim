
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Private Catalog
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enable cloud users to discover enterprise catalogs and products in their organizations.
## 
## https://cloud.google.com/private-catalog/
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
  gcpServiceName = "cloudprivatecatalog"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogOrganizationsCatalogsSearch_597677 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogOrganizationsCatalogsSearch_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/catalogs:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogOrganizationsCatalogsSearch_597678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. It can be in following formats:
  ## 
  ## * `projects/{project_id}`
  ## * `folders/{folder_id}`
  ## * `organizations/{organization_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_597805 = path.getOrDefault("resource")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "resource", valid_597805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
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
  ##   pageSize: JInt
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("pageToken")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "pageToken", valid_597808
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
  var valid_597824 = query.getOrDefault("query")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "query", valid_597824
  var valid_597825 = query.getOrDefault("oauth_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "oauth_token", valid_597825
  var valid_597826 = query.getOrDefault("callback")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "callback", valid_597826
  var valid_597827 = query.getOrDefault("access_token")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "access_token", valid_597827
  var valid_597828 = query.getOrDefault("uploadType")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "uploadType", valid_597828
  var valid_597829 = query.getOrDefault("key")
  valid_597829 = validateParameter(valid_597829, JString, required = false,
                                 default = nil)
  if valid_597829 != nil:
    section.add "key", valid_597829
  var valid_597830 = query.getOrDefault("$.xgafv")
  valid_597830 = validateParameter(valid_597830, JString, required = false,
                                 default = newJString("1"))
  if valid_597830 != nil:
    section.add "$.xgafv", valid_597830
  var valid_597831 = query.getOrDefault("pageSize")
  valid_597831 = validateParameter(valid_597831, JInt, required = false, default = nil)
  if valid_597831 != nil:
    section.add "pageSize", valid_597831
  var valid_597832 = query.getOrDefault("prettyPrint")
  valid_597832 = validateParameter(valid_597832, JBool, required = false,
                                 default = newJBool(true))
  if valid_597832 != nil:
    section.add "prettyPrint", valid_597832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597855: Call_CloudprivatecatalogOrganizationsCatalogsSearch_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_597855.validator(path, query, header, formData, body)
  let scheme = call_597855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597855.url(scheme.get, call_597855.host, call_597855.base,
                         call_597855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597855, url, valid)

proc call*(call_597926: Call_CloudprivatecatalogOrganizationsCatalogsSearch_597677;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogOrganizationsCatalogsSearch
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : Required. The name of the resource context. It can be in following formats:
  ## 
  ## * `projects/{project_id}`
  ## * `folders/{folder_id}`
  ## * `organizations/{organization_id}`
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597927 = newJObject()
  var query_597929 = newJObject()
  add(query_597929, "upload_protocol", newJString(uploadProtocol))
  add(query_597929, "fields", newJString(fields))
  add(query_597929, "pageToken", newJString(pageToken))
  add(query_597929, "quotaUser", newJString(quotaUser))
  add(query_597929, "alt", newJString(alt))
  add(query_597929, "query", newJString(query))
  add(query_597929, "oauth_token", newJString(oauthToken))
  add(query_597929, "callback", newJString(callback))
  add(query_597929, "access_token", newJString(accessToken))
  add(query_597929, "uploadType", newJString(uploadType))
  add(query_597929, "key", newJString(key))
  add(query_597929, "$.xgafv", newJString(Xgafv))
  add(path_597927, "resource", newJString(resource))
  add(query_597929, "pageSize", newJInt(pageSize))
  add(query_597929, "prettyPrint", newJBool(prettyPrint))
  result = call_597926.call(path_597927, query_597929, nil, nil, nil)

var cloudprivatecatalogOrganizationsCatalogsSearch* = Call_CloudprivatecatalogOrganizationsCatalogsSearch_597677(
    name: "cloudprivatecatalogOrganizationsCatalogsSearch",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/catalogs:search",
    validator: validate_CloudprivatecatalogOrganizationsCatalogsSearch_597678,
    base: "/", url: url_CloudprivatecatalogOrganizationsCatalogsSearch_597679,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogOrganizationsProductsSearch_597968 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogOrganizationsProductsSearch_597970(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/products:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogOrganizationsProductsSearch_597969(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_597971 = path.getOrDefault("resource")
  valid_597971 = validateParameter(valid_597971, JString, required = true,
                                 default = nil)
  if valid_597971 != nil:
    section.add "resource", valid_597971
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
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
  ##   pageSize: JInt
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597972 = query.getOrDefault("upload_protocol")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "upload_protocol", valid_597972
  var valid_597973 = query.getOrDefault("fields")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "fields", valid_597973
  var valid_597974 = query.getOrDefault("pageToken")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "pageToken", valid_597974
  var valid_597975 = query.getOrDefault("quotaUser")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "quotaUser", valid_597975
  var valid_597976 = query.getOrDefault("alt")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = newJString("json"))
  if valid_597976 != nil:
    section.add "alt", valid_597976
  var valid_597977 = query.getOrDefault("query")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "query", valid_597977
  var valid_597978 = query.getOrDefault("oauth_token")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "oauth_token", valid_597978
  var valid_597979 = query.getOrDefault("callback")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "callback", valid_597979
  var valid_597980 = query.getOrDefault("access_token")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "access_token", valid_597980
  var valid_597981 = query.getOrDefault("uploadType")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "uploadType", valid_597981
  var valid_597982 = query.getOrDefault("key")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "key", valid_597982
  var valid_597983 = query.getOrDefault("$.xgafv")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = newJString("1"))
  if valid_597983 != nil:
    section.add "$.xgafv", valid_597983
  var valid_597984 = query.getOrDefault("pageSize")
  valid_597984 = validateParameter(valid_597984, JInt, required = false, default = nil)
  if valid_597984 != nil:
    section.add "pageSize", valid_597984
  var valid_597985 = query.getOrDefault("prettyPrint")
  valid_597985 = validateParameter(valid_597985, JBool, required = false,
                                 default = newJBool(true))
  if valid_597985 != nil:
    section.add "prettyPrint", valid_597985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597986: Call_CloudprivatecatalogOrganizationsProductsSearch_597968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_597986.validator(path, query, header, formData, body)
  let scheme = call_597986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597986.url(scheme.get, call_597986.host, call_597986.base,
                         call_597986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597986, url, valid)

proc call*(call_597987: Call_CloudprivatecatalogOrganizationsProductsSearch_597968;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogOrganizationsProductsSearch
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597988 = newJObject()
  var query_597989 = newJObject()
  add(query_597989, "upload_protocol", newJString(uploadProtocol))
  add(query_597989, "fields", newJString(fields))
  add(query_597989, "pageToken", newJString(pageToken))
  add(query_597989, "quotaUser", newJString(quotaUser))
  add(query_597989, "alt", newJString(alt))
  add(query_597989, "query", newJString(query))
  add(query_597989, "oauth_token", newJString(oauthToken))
  add(query_597989, "callback", newJString(callback))
  add(query_597989, "access_token", newJString(accessToken))
  add(query_597989, "uploadType", newJString(uploadType))
  add(query_597989, "key", newJString(key))
  add(query_597989, "$.xgafv", newJString(Xgafv))
  add(path_597988, "resource", newJString(resource))
  add(query_597989, "pageSize", newJInt(pageSize))
  add(query_597989, "prettyPrint", newJBool(prettyPrint))
  result = call_597987.call(path_597988, query_597989, nil, nil, nil)

var cloudprivatecatalogOrganizationsProductsSearch* = Call_CloudprivatecatalogOrganizationsProductsSearch_597968(
    name: "cloudprivatecatalogOrganizationsProductsSearch",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/products:search",
    validator: validate_CloudprivatecatalogOrganizationsProductsSearch_597969,
    base: "/", url: url_CloudprivatecatalogOrganizationsProductsSearch_597970,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogOrganizationsVersionsSearch_597990 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogOrganizationsVersionsSearch_597992(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/versions:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogOrganizationsVersionsSearch_597991(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_597993 = path.getOrDefault("resource")
  valid_597993 = validateParameter(valid_597993, JString, required = true,
                                 default = nil)
  if valid_597993 != nil:
    section.add "resource", valid_597993
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
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
  ##   pageSize: JInt
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597994 = query.getOrDefault("upload_protocol")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "upload_protocol", valid_597994
  var valid_597995 = query.getOrDefault("fields")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "fields", valid_597995
  var valid_597996 = query.getOrDefault("pageToken")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "pageToken", valid_597996
  var valid_597997 = query.getOrDefault("quotaUser")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "quotaUser", valid_597997
  var valid_597998 = query.getOrDefault("alt")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("json"))
  if valid_597998 != nil:
    section.add "alt", valid_597998
  var valid_597999 = query.getOrDefault("query")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "query", valid_597999
  var valid_598000 = query.getOrDefault("oauth_token")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "oauth_token", valid_598000
  var valid_598001 = query.getOrDefault("callback")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "callback", valid_598001
  var valid_598002 = query.getOrDefault("access_token")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "access_token", valid_598002
  var valid_598003 = query.getOrDefault("uploadType")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "uploadType", valid_598003
  var valid_598004 = query.getOrDefault("key")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "key", valid_598004
  var valid_598005 = query.getOrDefault("$.xgafv")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = newJString("1"))
  if valid_598005 != nil:
    section.add "$.xgafv", valid_598005
  var valid_598006 = query.getOrDefault("pageSize")
  valid_598006 = validateParameter(valid_598006, JInt, required = false, default = nil)
  if valid_598006 != nil:
    section.add "pageSize", valid_598006
  var valid_598007 = query.getOrDefault("prettyPrint")
  valid_598007 = validateParameter(valid_598007, JBool, required = false,
                                 default = newJBool(true))
  if valid_598007 != nil:
    section.add "prettyPrint", valid_598007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598008: Call_CloudprivatecatalogOrganizationsVersionsSearch_597990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_598008.validator(path, query, header, formData, body)
  let scheme = call_598008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598008.url(scheme.get, call_598008.host, call_598008.base,
                         call_598008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598008, url, valid)

proc call*(call_598009: Call_CloudprivatecatalogOrganizationsVersionsSearch_597990;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogOrganizationsVersionsSearch
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598010 = newJObject()
  var query_598011 = newJObject()
  add(query_598011, "upload_protocol", newJString(uploadProtocol))
  add(query_598011, "fields", newJString(fields))
  add(query_598011, "pageToken", newJString(pageToken))
  add(query_598011, "quotaUser", newJString(quotaUser))
  add(query_598011, "alt", newJString(alt))
  add(query_598011, "query", newJString(query))
  add(query_598011, "oauth_token", newJString(oauthToken))
  add(query_598011, "callback", newJString(callback))
  add(query_598011, "access_token", newJString(accessToken))
  add(query_598011, "uploadType", newJString(uploadType))
  add(query_598011, "key", newJString(key))
  add(query_598011, "$.xgafv", newJString(Xgafv))
  add(path_598010, "resource", newJString(resource))
  add(query_598011, "pageSize", newJInt(pageSize))
  add(query_598011, "prettyPrint", newJBool(prettyPrint))
  result = call_598009.call(path_598010, query_598011, nil, nil, nil)

var cloudprivatecatalogOrganizationsVersionsSearch* = Call_CloudprivatecatalogOrganizationsVersionsSearch_597990(
    name: "cloudprivatecatalogOrganizationsVersionsSearch",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/versions:search",
    validator: validate_CloudprivatecatalogOrganizationsVersionsSearch_597991,
    base: "/", url: url_CloudprivatecatalogOrganizationsVersionsSearch_597992,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
